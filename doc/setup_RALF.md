# Setup *IIC-RALF* in your *IIC-OSIC-TOOLS* container

All details may be found in `IIC-RALF/README.md`

1. Copy IIC-RALF into your container and install Python packages
    + Open console of container
    + `cd ~`
    + `git clone https://github.com/iic-jku/IIC-RALF`
    + `pip install -r requirements.txt`
2. Create netlist of `amp.sch` in Xschem
3. Copy netlist to design directory
   + `cp ~/.xschem/simulations/amp.spice /foss/designs`
4. Modify NetlistRules file `xschem/netlist_rules_amp.json` if needed
5. Setup simulated annealing `main_RP_placement.py` or reinforcement learning `main_RL_placement.py` based placement
    + Open the respective file, e.g. `nano main_RP_placement.py`
    + Set the following global variables 
      + `CIRCUIT_FILE = "/foss/designs/amp.spice"`
      + `CIRCUIT_NAME = "amp"`
      + `NET_RULES_FILE = "/foss/designs/net_rules_amp.json"`
6. Run placement
   + `python3 main_RP_placement.py`
