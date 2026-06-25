-- ArakelovRH.lean -- Top-level barrel for the canonical RH proof package.
-- David Fox -- Opera Numerorum -- 2026
-- _root_.RiemannHypothesis (Mathlib v4.12.0) is the GENUINE predicate, not True.
-- Mathematical sources:
--   DavidFox998/ClassNumber-143  (class number, genus, norm forms, Hasse)
--   DavidFox998/rh-p5-bridge-14  (chain C01-C22, Hecke, Langlands)
import ArakelovRH.C01_Arakelov
import ArakelovRH.C02_Modularity
import ArakelovRH.C03_Positivity
import ArakelovRH.C04_HeightBound
import ArakelovRH.C05_Discriminant
import ArakelovRH.C06_BostConnes
import ArakelovRH.C07_RHCombinator
import ArakelovRH.C08_Positivity
import ArakelovRH.C11_ArakelovPairing
import ArakelovRH.C14_SpectralGap
import ArakelovRH.Master
import ArakelovRH.Scaffold.GrowthContradiction
import ArakelovRH.Scaffold.IwaniecKowalski
import ArakelovRH.Scaffold.ConverseTheorem
import ArakelovRH.Scaffold.AbbesUllmo
import ArakelovRH.Scaffold.JorgensonKramer
import ArakelovRH.Scaffold.KimSarnakAuxiliary
import ArakelovRH.Scaffold.KimSarnakMainTheorem
import ArakelovRH.C09_GRHDescent
import ArakelovRH.C10_RHMainTheorem
import ArakelovRH.ClassNumber.GenusFormula
import ArakelovRH.ClassNumber.ReducedForms
import ArakelovRH.ClassNumber.NormFormBounds
