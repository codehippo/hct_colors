Color generating library
----

Library utilises Google's HCT colour space to create tones (shades or tints) of seed colours.

Due to the irregularity of sRGB gamut in HCT colour space, an algorithm that iteratively constricts gamut in certain
hues is applied for greater uniformity of the potential colour palette.

This effect is more pronounced in the lightest tints and darkest shades of colours so the gamut reduction is greatest in
these values. This behaviour can be modified using dynamic ranges in code.

Usage
---
Input `seed_colors.csv` values together with HEX codes and the library takes care of the rest, generating an Excel file
called `output.xlsx` with the palettes for each colour presented as a separate sheet.