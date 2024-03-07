# Usage of `filter_design.py`

## Requirements
- **kvosid_336004_ss24** GitHub Repo (clone or download)
  - `git clone https://github.com/iic-jku/kvosid_336004_ss24.git`


- conda (Miniconda, see **Links** section)
    - `conda create -n filter python numpy scipy sympy`


- Python Control Toolbox
  - `pip install control`

## Options 
- Pass-band gain: `a_pass`
- Corner frequency (-3dB): `f_pass`

## Run python
- `conda activate filter`

- `python filter_design.py`

## Links
- [Miniconda](https://docs.anaconda.com/free/miniconda/index.html)
- [scipy.signal.iirfilter](https://docs.scipy.org/doc/scipy/reference/generated/scipy.signal.iirfilter.html#scipy.signal.iirfilter)
- [scipy.signal.iirdesign](https://docs.scipy.org/doc/scipy/reference/generated/scipy.signal.iirdesign.html#scipy.signal.iirdesign)
- [Python Control Toolbox Matlab Mode](https://python-control.readthedocs.io/en/0.9.4/matlab.html)

