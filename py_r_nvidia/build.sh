sudo -E docker build --secret id=github_token,env=GH_TOKEN -t ghcr.io/marcalva/py_r_nvidia:1.0 .
