# Usage of _filter_design.py_

## Requirements
- *kvosid_336004_ss24* GitHub Repo (clone or download)
  - `git clone https://github.com/iic-jku/kvosid_336004_ss24.git`


- conda (Miniconda, see *Links* section)
    - `conda create -n filter python numpy scipy sympy`


- Python Control Toolbox
  - pip install control

## Options 
- Pass-band gain: `a_pass`
- Corner frequency (-3dB): `f_pass`

## Run python
- `conda activate filter`

- `python filter_design.py`

## Links
- https://docs.anaconda.com/free/miniconda/index.html
- https://docs.scipy.org/doc/scipy/reference/generated/scipy.signal.iirfilter.html#scipy.signal.iirfilter
- https://docs.scipy.org/doc/scipy/reference/generated/scipy.signal.iirdesign.html#scipy.signal.iirdesign
- https://python-control.readthedocs.io/en/0.9.4/matlab.html

