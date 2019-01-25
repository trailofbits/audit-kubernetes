# Overview

This repo is meant to hold:

- the source code for Kubernetes (`./src/`)
- the source code for any tools or notes (`./notes/`)
- any screenshots (`./screenshots/`) 
- and the requisite data created during the assessment (`./data`)

This assessment is going to be **enormous**:

```
% cloc .
   18293 text files.
   17039 unique files.                                          
    4980 files ignored.

github.com/AlDanial/cloc v 1.80  T=40.75 s (327.8 files/s, 118447.1 lines/s)
--------------------------------------------------------------------------------
Language                      files          blank        comment           code
--------------------------------------------------------------------------------
Go                            11333         394508         603722        2714636
JSON                            142              8              0         380682
HTML                             70           4209              1         288379
C                                 6          14286          65219         126040
Markdown                        410          12713              0          40042
YAML                            619            880           1073          31798
Bourne Shell                    350           5683          10837          27000
PO File                          11           1240           1755          13639
JavaScript                       17           1550           2271           9910
Protocol Buffers                101           4962          15019           9862
Assembly                         84           1613           2041           8905
Python                           16            858            852           3239
C/C++ Header                      4            705          13388           2835
make                             73            516           1116           1605
CSS                               3              0              5           1402
Perl                              8            142            131            855
Dockerfile                       70            275           1000            642
yacc                              1             47            110            527
Lua                               1             30             26            453
sed                               4              4             32            376
Bourne Again Shell               13             72             28            370
TOML                              9            127            131            223
Skylark                           9             30            140            179
INI                               2              4              0             20
Gradle                            1              2              0             16
--------------------------------------------------------------------------------
SUM:                          13357         444464         718897        3663635
--------------------------------------------------------------------------------
```

Please:

- keep detailed notes about what you were working on and when, in a logbook format
- add findings *as you find them* and not after

We've added some templates in `./data/templates` to help keep notes & findings in similar format for mass consumption.

If you have any questions, please feel free to ask! 

- The Garden Keeper (aka Stefan)

# ICS-style project management

ICS, or [Incident Command System](https://en.wikipedia.org/wiki/Incident_Command_System) is a system of management for
distributed and fluid teams in times of crisis. It has a few useful points we should adhere to:

- Objective-based management: each team will have a lead, the lead will be responsible for that area.
- Accountability and professionalism: each person will know their project area, and be responsible for maintaining that section of the project
- Unified Command Structure: folks should report to their team leads, team leads to the project leads from ToB & Atredis
- Unified Terminiology: this is key: we **must** use the same terminiology across teams and projects.

For example: we must decide on Kubernetes vs k8s early on, and **only** use that terminiology. All other variants **must** be rewritten to the 
decided upon terms. The sole exception is quotation from other sources that may use a different term.
