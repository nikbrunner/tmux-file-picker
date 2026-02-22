.PHONY: install uninstall help

BINARY := tmux-file-picker
INSTALL_DIR := $(HOME)/.local/bin

install:
	mkdir -p $(INSTALL_DIR)
	rm -f $(INSTALL_DIR)/$(BINARY)
	ln -s $(CURDIR)/$(BINARY) $(INSTALL_DIR)/$(BINARY)
	@echo "Linked $(INSTALL_DIR)/$(BINARY) -> $(CURDIR)/$(BINARY)"

uninstall:
	rm -f $(INSTALL_DIR)/$(BINARY)
	@echo "Removed $(BINARY) from $(INSTALL_DIR)"

help:
	@echo "Available targets:"
	@echo "  install   - Install to ~/.local/bin"
	@echo "  uninstall - Remove from ~/.local/bin"
	@echo "  help      - Show this help"

.DEFAULT_GOAL := help
