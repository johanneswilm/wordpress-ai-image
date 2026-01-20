#!/bin/bash

# AI Image Marker - Build Script
# Creates a distributable ZIP file of the WordPress plugin

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PLUGIN_SLUG="ai-image-marker"
PLUGIN_DIR="ai-image-marker"
BUILD_DIR="build"
RELEASE_DIR="release"
VERSION=$(grep "Version:" ${PLUGIN_DIR}/ai-image-marker.php | awk '{print $3}')

# Functions
print_header() {
    echo -e "${BLUE}================================================${NC}"
    echo -e "${BLUE}  AI Image Marker - Build Script${NC}"
    echo -e "${BLUE}  Version: ${VERSION}${NC}"
    echo -e "${BLUE}================================================${NC}"
    echo ""
}

print_step() {
    echo -e "${GREEN}➜${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Check if we're in the right directory
check_directory() {
    if [ ! -d "$PLUGIN_DIR" ]; then
        print_error "Plugin directory '$PLUGIN_DIR' not found!"
        print_warning "Please run this script from the project root directory."
        exit 1
    fi
}

# Clean previous builds
clean_build() {
    print_step "Cleaning previous builds..."
    if [ -d "$BUILD_DIR" ]; then
        rm -rf "$BUILD_DIR"
    fi
    mkdir -p "$BUILD_DIR"
    print_success "Build directory cleaned"
}

# Compile translations
compile_translations() {
    print_step "Compiling translations..."
    
    # Check if msgfmt is available
    if ! command -v msgfmt &> /dev/null; then
        print_warning "msgfmt not found - skipping translation compilation"
        print_warning "Install gettext tools to enable: sudo apt-get install gettext"
        return
    fi
    
    # Compile Norwegian translation
    if [ -f "${PLUGIN_DIR}/languages/ai-image-marker-nb_NO.po" ]; then
        msgfmt "${PLUGIN_DIR}/languages/ai-image-marker-nb_NO.po" \
               -o "${PLUGIN_DIR}/languages/ai-image-marker-nb_NO.mo"
        print_success "Norwegian (nb_NO) translation compiled"
    fi
}

# Copy plugin files
copy_files() {
    print_step "Copying plugin files..."
    
    # Create plugin directory in build
    mkdir -p "${BUILD_DIR}/${PLUGIN_SLUG}"
    
    # Copy main plugin files
    cp "${PLUGIN_DIR}/ai-image-marker.php" "${BUILD_DIR}/${PLUGIN_SLUG}/"
    cp "${PLUGIN_DIR}/admin.js" "${BUILD_DIR}/${PLUGIN_SLUG}/"
    cp "${PLUGIN_DIR}/LICENSE" "${BUILD_DIR}/${PLUGIN_SLUG}/"
    cp "${PLUGIN_DIR}/README.md" "${BUILD_DIR}/${PLUGIN_SLUG}/"
    cp "${PLUGIN_DIR}/INSTALL.md" "${BUILD_DIR}/${PLUGIN_SLUG}/"
    cp "${PLUGIN_DIR}/QUICKSTART.md" "${BUILD_DIR}/${PLUGIN_SLUG}/"
    cp "${PLUGIN_DIR}/EXAMPLES.md" "${BUILD_DIR}/${PLUGIN_SLUG}/"
    cp "${PLUGIN_DIR}/CHANGELOG.md" "${BUILD_DIR}/${PLUGIN_SLUG}/"
    
    # Copy language files
    mkdir -p "${BUILD_DIR}/${PLUGIN_SLUG}/languages"
    cp "${PLUGIN_DIR}/languages/"*.pot "${BUILD_DIR}/${PLUGIN_SLUG}/languages/" 2>/dev/null || true
    cp "${PLUGIN_DIR}/languages/"*.po "${BUILD_DIR}/${PLUGIN_SLUG}/languages/" 2>/dev/null || true
    cp "${PLUGIN_DIR}/languages/"*.mo "${BUILD_DIR}/${PLUGIN_SLUG}/languages/" 2>/dev/null || true
    
    print_success "Files copied to build directory"
}

# Create ZIP file
create_zip() {
    print_step "Creating ZIP file..."
    
    # Create release directory
    mkdir -p "$RELEASE_DIR"
    
    # Generate filename with version
    ZIP_NAME="${PLUGIN_SLUG}-${VERSION}.zip"
    ZIP_PATH="${RELEASE_DIR}/${ZIP_NAME}"
    
    # Remove old zip if exists
    if [ -f "$ZIP_PATH" ]; then
        rm "$ZIP_PATH"
    fi
    
    # Create ZIP
    cd "$BUILD_DIR"
    zip -r "../${ZIP_PATH}" "${PLUGIN_SLUG}" -q
    cd ..
    
    # Get file size
    FILE_SIZE=$(du -h "$ZIP_PATH" | cut -f1)
    
    print_success "ZIP file created: ${ZIP_PATH} (${FILE_SIZE})"
}

# Verify ZIP contents
verify_zip() {
    print_step "Verifying ZIP contents..."
    
    ZIP_PATH="${RELEASE_DIR}/${PLUGIN_SLUG}-${VERSION}.zip"
    
    echo ""
    echo "Contents of ${ZIP_NAME}:"
    unzip -l "$ZIP_PATH" | tail -n +4 | head -n -2
    echo ""
}

# Display summary
show_summary() {
    echo ""
    echo -e "${GREEN}================================================${NC}"
    echo -e "${GREEN}  Build Complete!${NC}"
    echo -e "${GREEN}================================================${NC}"
    echo ""
    echo "Plugin: ${PLUGIN_SLUG}"
    echo "Version: ${VERSION}"
    echo "Output: ${RELEASE_DIR}/${PLUGIN_SLUG}-${VERSION}.zip"
    echo ""
    echo "Installation:"
    echo "  1. Upload to WordPress via Plugins → Add New → Upload"
    echo "  2. Or extract to: wp-content/plugins/"
    echo "  3. Activate in WordPress admin"
    echo ""
}

# Cleanup function for errors
cleanup_on_error() {
    print_error "Build failed!"
    if [ -d "$BUILD_DIR" ]; then
        rm -rf "$BUILD_DIR"
    fi
    exit 1
}

# Main execution
main() {
    # Set up error handler
    trap cleanup_on_error ERR
    
    print_header
    
    check_directory
    clean_build
    compile_translations
    copy_files
    create_zip
    verify_zip
    show_summary
    
    # Clean up build directory
    print_step "Cleaning up..."
    rm -rf "$BUILD_DIR"
    print_success "Build directory removed"
    
    echo ""
    print_success "All done! 🎉"
    echo ""
}

# Run main function
main