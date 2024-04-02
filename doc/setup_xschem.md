# Setup *Xschem* Library Path 

1. Personal virtual machine
    - Open terminal, go to `/foss/designs/`
        - `cd /foss/designs`
    - Clone Github-Repo to `/foss/design/`
        - `git clone https://github.com/iic-jku/kvosid_336004_ss24.git`
    - Open `.designinit`
        - e.g. `gedit .designinit &`
    - Change `XSCHEM_USER_LIBRARY_PATH` to `/foss/design/kvosid_336004_ss24/xschem`

    - Source `.designinit`
        - `source .designinit`
    - Open a schematic with *Xschem*
        - e.g. `xschem xschem/tb_filter_cl.sch`

2. Local Docker-based installation of *IIC-OSIC-TOOLS*

    - Copy template script `doc/start_eda_template.sh` to a path of your choice 
        - e.g. `cp <path-to-github-repo>/doc/template_start_eda.sh <path>/start_eda.sh`

    - Set `DESIGNS` path of local Github Repo inside `<path>/start_eda.sh`, this will map to `/foss/designs/` in the Docker container
        - e.g. `export DESIGNS=/home/maxm/projects/kvosid_336004_ss24/`

    - Set Path to `IIC-OSIC-TOOLS`, either `start_x.sh` or `start_vnc.sh`

    - Call script
        - `sh <path>/start_eda.sh`
