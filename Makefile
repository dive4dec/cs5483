activate_jupyterbook = . ${CONDA_DIR}/bin/activate && conda activate jupyterbook
activate_jupyterlite = . ${CONDA_DIR}/bin/activate && conda activate jupyterlite

jupyterbook_env: .built_jupyterbook_env
.built_jupyterbook_env: jupyterbook/dep/*
	@if conda env list | grep '^jupyterbook\s' > /dev/null; then \
        echo "Jupyterbook environment exists, deleting..."; \
        conda env remove --name jupyterbook; \
    else \
        echo "Jupyterbook environment does not exist"; \
    fi
	@conda env create -p ${CONDA_DIR}/envs/jupyterbook -f jupyterbook/dep/environment.yml && \
	touch .built_jupyterbook_env

jupyterbook:
	$(activate_jupyterbook) && \
	jupyter-book build --config=jupyterbook/_config.yml --toc=jupyterbook/_toc.yml --path-output=dist/jupyterbook .
	# python -m http.server -d dist/jupyterbook/_build/html 1111

jupyterlite_env: .built_jupyterlite_env
.built_jupyterlite_env: jupyterlite/dep/*
	@if conda env list | grep '^jupyterlite\s' > /dev/null; then \
        echo "jupyterlite environment exists, deleting..."; \
        conda env remove --name jupyterlite; \
    else \
        echo "jupyterlite environment does not exist"; \
    fi
	@conda env create -p ${CONDA_DIR}/envs/jupyterlite -f jupyterlite/dep/environment.yml && \
	touch .built_jupyterlite_env

jupyterlite:
	$(activate_jupyterlite) && \
	jupyter lite build --lite-dir=jupyterlite --contents=. --output-dir=dist/jupyterlite
	# python kernel2pyodide.py

clean.jupyterbook:
	jupyter-book clean dist/jupyterbook

clean:
	rm -rf dist

.PHONY: jupyterbook_env jupyterbook jupyterlite_env jupyterlite clean clean.%