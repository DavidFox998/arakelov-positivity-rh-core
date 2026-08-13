# ArakelovRH — C-chain ROOT V2

C-chain `C01` through `C14` — arithmetic geometry to RH.

- `C01_Arakelov.lean` — `ArakelovPositivity X₀ 143` `ω²=48/13>0` `norm_num` — input for keystone
- `C02_Modularity.lean` — Eichler-Shimura `L(s,X₀143)=L(s,f143a1)`
- `C06_BostConnes.lean` — `C(S₄)=11.422... >2√13` `C_S4_143_gt_tau` — reuses **[bost-connes](https://github.com/DavidFox998/bost-connes)** M3
- `C07_RHCombinator.lean` — BC6 gate `M1+M2→M3`
- `C09_GRHDescent.lean` — GRH descent
- `ClayCertificate.lean` — `clay_certificate_kim_sarnak` [B77]
- `RouteBClosed.lean` — `gate_m1_inputs_discharged`

Provides `48/13>0` for **[rh-p5-bridge-14](https://github.com/DavidFox998/rh-p5-bridge-14)** `q5=226 q6=165849 cf_bound=82829`.
