# Makefile for AI Image Marker WordPress Plugin

# Variables
PLUGIN_SLUG = ai-image-marker
PLUGIN_DIR = ai-image-marker
BUILD_DIR = build
RELEASE_DIR = release
VERSION = $(shell grep "Version:" $(PLUGIN_DIR)/ai-image-marker.php | awk '{print $$3}')
ZIP_FILE = $(RELEASE_DIR)/$(PLUGIN_SLUG)-$(VERSION).zip

# Colors
GREEN = \033[0;32m
YELLOW = \033[1;33m
BLUE = \033[0;34m
NC = \033[0m

# Default target
.PHONY: help
help:
	@echo "$(BLUE)AI Image Marker - Build Commands$(NC)"
	@echo ""
	@echo "Available commands:"
	@echo "  $(GREEN)make build$(NC)       - Build plugin ZIP file"
	@echo "  $(GREEN)make clean$(NC)       - Clean build artifacts"
	@echo "  $(GREEN)make translations$(NC) - Compile translation files"
	@echo "  $(GREEN)make verify$(NC)      - Verify ZIP contents"
	@echo "  $(GREEN)make install$(NC)     - Build and show install instructions"
	@echo "  $(GREEN)make dev-install$(NC) - Copy plugin to local WordPress (set WP_PATH)"
	@echo "  $(GREEN)make version$(NC)     - Show current version"
	@echo ""

# Show version
.PHONY: version
version:
	@echo "Version: $(VERSION)"

# Clean build artifacts
.PHONY: clean
clean:
	@echo "$(YELLOW)Cleaning build artifacts...$(NC)"
	@rm -rf $(BUILD_DIR)
	@rm -f $(RELEASE_DIR)/*.zip
	@echo "$(GREEN)✓ Clean complete$(NC)"

# Compile translations
.PHONY: translations
translations:
	@echo "$(YELLOW)Compiling translations...$(NC)"
	@if command -v msgfmt >/dev/null 2>&1; then \
		if [ -f "$(PLUGIN_DIR)/languages/ai-image-marker-nb_NO.po" ]; then \
			msgfmt $(PLUGIN_DIR)/languages/ai-image-marker-nb_NO.po \
			       -o $(PLUGIN_DIR)/languages/ai-image-marker-nb_NO.mo; \
			echo "$(GREEN)✓ Norwegian translation compiled$(NC)"; \
		fi; \
	else \
		echo "$(YELLOW)⚠ msgfmt not found - install gettext tools$(NC)"; \
	fi

# Build plugin
.PHONY: build
build: clean translations
	@echo "$(YELLOW)Building plugin ZIP...$(NC)"
	@mkdir -p $(BUILD_DIR)/$(PLUGIN_SLUG)
	@mkdir -p $(RELEASE_DIR)
	
	@# Copy main files
	@cp $(PLUGIN_DIR)/ai-image-marker.php $(BUILD_DIR)/$(PLUGIN_SLUG)/
	@cp $(PLUGIN_DIR)/admin.js $(BUILD_DIR)/$(PLUGIN_SLUG)/
	@cp $(PLUGIN_DIR)/LICENSE $(BUILD_DIR)/$(PLUGIN_SLUG)/
	@cp $(PLUGIN_DIR)/README.md $(BUILD_DIR)/$(PLUGIN_SLUG)/
	@cp $(PLUGIN_DIR)/INSTALL.md $(BUILD_DIR)/$(PLUGIN_SLUG)/
	@cp $(PLUGIN_DIR)/QUICKSTART.md $(BUILD_DIR)/$(PLUGIN_SLUG)/
	@cp $(PLUGIN_DIR)/EXAMPLES.md $(BUILD_DIR)/$(PLUGIN_SLUG)/
	@cp $(PLUGIN_DIR)/CHANGELOG.md $(BUILD_DIR)/$(PLUGIN_SLUG)/
	
	@# Copy language files
	@mkdir -p $(BUILD_DIR)/$(PLUGIN_SLUG)/languages
	@cp $(PLUGIN_DIR)/languages/*.pot $(BUILD_DIR)/$(PLUGIN_SLUG)/languages/ 2>/dev/null || true
	@cp $(PLUGIN_DIR)/languages/*.po $(BUILD_DIR)/$(PLUGIN_SLUG)/languages/ 2>/dev/null || true
	@cp $(PLUGIN_DIR)/languages/*.mo $(BUILD_DIR)/$(PLUGIN_SLUG)/languages/ 2>/dev/null || true
	
	@# Create ZIP
	@cd $(BUILD_DIR) && zip -r ../$(ZIP_FILE) $(PLUGIN_SLUG) -q
	@rm -rf $(BUILD_DIR)
	
	@echo "$(GREEN)✓ Build complete: $(ZIP_FILE)$(NC)"
	@echo "$(GREEN)  Size: $$(du -h $(ZIP_FILE) | cut -f1)$(NC)"

# Verify ZIP contents
.PHONY: verify
verify:
	@if [ ! -f "$(ZIP_FILE)" ]; then \
		echo "$(YELLOW)No ZIP file found. Run 'make build' first.$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)Contents of $(PLUGIN_SLUG)-$(VERSION).zip:$(NC)"
	@unzip -l $(ZIP_FILE)

# Build and show install instructions
.PHONY: install
install: build
	@echo ""
	@echo "$(GREEN)Installation Instructions:$(NC)"
	@echo ""
	@echo "Method 1 - WordPress Admin:"
	@echo "  1. Go to WordPress Admin → Plugins → Add New → Upload"
	@echo "  2. Choose file: $(ZIP_FILE)"
	@echo "  3. Click 'Install Now' then 'Activate'"
	@echo ""
	@echo "Method 2 - Manual:"
	@echo "  unzip $(ZIP_FILE) -d /path/to/wordpress/wp-content/plugins/"
	@echo ""

# Install to local WordPress development site
.PHONY: dev-install
dev-install: build
	@if [ -z "$(WP_PATH)" ]; then \
		echo "$(YELLOW)Error: WP_PATH not set$(NC)"; \
		echo "Usage: make dev-install WP_PATH=/path/to/wordpress"; \
		exit 1; \
	fi
	@if [ ! -d "$(WP_PATH)/wp-content/plugins" ]; then \
		echo "$(YELLOW)Error: $(WP_PATH)/wp-content/plugins not found$(NC)"; \
		exit 1; \
	fi
	@echo "$(YELLOW)Installing to $(WP_PATH)...$(NC)"
	@rm -rf $(WP_PATH)/wp-content/plugins/$(PLUGIN_SLUG)
	@unzip -q $(ZIP_FILE) -d $(WP_PATH)/wp-content/plugins/
	@echo "$(GREEN)✓ Installed to $(WP_PATH)/wp-content/plugins/$(PLUGIN_SLUG)$(NC)"
	@echo "$(BLUE)Activate it in WordPress admin!$(NC)"

# Quick rebuild
.PHONY: rebuild
rebuild: clean build

# Run build script (alternative)
.PHONY: build-script
build-script:
	@./build.sh

# All (build + verify)
.PHONY: all
all: build verify

# Check for required tools
.PHONY: check
check:
	@echo "$(BLUE)Checking build requirements...$(NC)"
	@command -v zip >/dev/null 2>&1 || { echo "$(YELLOW)⚠ zip not found$(NC)"; }
	@command -v msgfmt >/dev/null 2>&1 || { echo "$(YELLOW)⚠ msgfmt not found (translation compilation disabled)$(NC)"; }
	@command -v php >/dev/null 2>&1 || { echo "$(YELLOW)⚠ php not found$(NC)"; }
	@echo "$(GREEN)✓ Check complete$(NC)"