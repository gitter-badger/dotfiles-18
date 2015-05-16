.DEFAULT_GOAL := install

install:
	@cd dotfiles; \
	for f in $$(ls); do \
		if [ -f ~/.$$f ]; then \
			if [ ! -L ~/.$$f ]; then \
				if [ -f ~/.$$f.dotfiles.bak ]; then \
					echo "exsits backup file: ~/.$$f.dotfiles.bak"; \
				else \
					echo "backup old file: mv ~/.$$f{,.dotfiles.bak}"; \
					mv ~/.$$f{,.dotfiles.bak}; \
				fi; \
			else \
				oldlink="`readlink ~/.$$f`"; \
				if [ "$$oldlink" != "`pwd`/$$f" ]; then \
					echo "remove old link: rm ~/.$$f (-> $$oldlink)"; \
					rm ~/.$$f; \
				else \
					echo "exists link: ~/.$$f -> `pwd`/$$f"; \
				fi; \
			fi; \
		fi; \
		if [ ! -f ~/.$$f ]; then \
			echo "create link: ln -s `pwd`/$$f ~/.$$f"; \
			ln -sf `pwd`/$$f ~/.$$f; \
		fi; \
	done

uninstall:
	@cd dotfiles; \
	for f in $$(ls); do \
		if [ -L ~/.$$f ]; then \
			if [ -f ~/.$$f.dotfiles.bak ]; then \
				echo "restore old file: mv ~/.$$f{.dotfiles.bak,}"; \
				mv ~/.$$f{.dotfiles.bak,}; \
			else \
				echo "remove link: rm ~/.$$f"; \
				rm ~/.$$f; \
			fi; \
		fi; \
	done
