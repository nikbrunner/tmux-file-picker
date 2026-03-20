.PHONY: install install-config uninstall help

BINARY := tmux-file-picker
INSTALL_DIR := $(HOME)/.local/bin
CONFIG_DIR := $(or $(XDG_CONFIG_HOME),$(HOME)/.config)/tmux-file-picker

install:
	mkdir -p $(INSTALL_DIR)
	rm -f $(INSTALL_DIR)/$(BINARY)
	ln -s $(CURDIR)/$(BINARY) $(INSTALL_DIR)/$(BINARY)
	@echo "Linked $(INSTALL_DIR)/$(BINARY) -> $(CURDIR)/$(BINARY)"

install-config:
	mkdir -p $(CONFIG_DIR)
	@if [ -f $(CONFIG_DIR)/config ]; then \
		echo "Config already exists at $(CONFIG_DIR)/config — skipping"; \
	else \
		cp $(CURDIR)/config.example $(CONFIG_DIR)/config; \
		echo "Installed config to $(CONFIG_DIR)/config"; \
	fi

uninstall:
	rm -f $(INSTALL_DIR)/$(BINARY)
	@echo "Removed $(BINARY) from $(INSTALL_DIR)"

help:
	@echo "Available targets:"
	@echo "  install        - Install to ~/.local/bin"
	@echo "  install-config - Copy config.example to ~/.config/tmux-file-picker/config"
	@echo "  uninstall      - Remove from ~/.local/bin"
	@echo "  help           - Show this help"

.DEFAULT_GOAL := help
