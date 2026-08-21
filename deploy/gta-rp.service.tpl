[Unit]
Description=Serveur GTA RP (FXServer)
After=network.target docker.service

[Service]
Type=simple
User={{USER}}
WorkingDirectory={{WORKDIR}}
ExecStart={{WORKDIR}}/run.sh +exec {{CFG}}
Restart=always
RestartSec=5
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
