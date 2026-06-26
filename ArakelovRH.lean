-- ArakelovRH.lean -- Top-level barrel for the canonical RH proof package.
-- David Fox -- Opera Numerorum -- 2026
-- _root_.RiemannHypothesis (Mathlib v4.12.0) is the GENUINE predicate, not True.
-- Mathematical sources:
--   DavidFox998/ClassNumber-143      (class number, genus, norm forms, Hasse)
--   DavidFox998/yang-mills-gap       (spectral gap machinery, read-only reference)
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
import ArakelovRH.Spectral.SpectralAbstract
import ArakelovRH.Spectral.SelbergTrace143
import ArakelovRH.Spectral.KimSarnakChain
import ArakelovRH.RHRouteA
import ArakelovRH.RouteBClosure
import ArakelovRH.ZeroDensity
import ArakelovRH.RHCoreProof
import ArakelovRH.RouteBClosed
import ArakelovRH.RHRouteB
import ArakelovRH.Master
import ArakelovRH.Scaffold.GrowthContradiction
import ArakelovRH.Scaffold.IwaniecKowalski
import ArakelovRH.Scaffold.ConverseTheorem
import ArakelovRH.Scaffold.AbbesUllmo
import ArakelovRH.Scaffold.JorgensonKramer
import ArakelovRH.Scaffold.KimSarnakAuxiliary
import ArakelovRH.Scaffold.KimSarnakMainTheorem
import ArakelovRH.Scaffold.RouteBReduction
import ArakelovRH.C09_GRHDescent
import ArakelovRH.C10_RHMainTheorem
import ArakelovRH.ClassNumber.GenusFormula
import ArakelovRH.ClassNumber.ReducedForms
import ArakelovRH.ClassNumber.NormFormBounds
import ArakelovRH.Closure.EulerProductClosure
import ArakelovRH.Closure.ResidueArgumentClosure
import ArakelovRH.Closure.BoundedStripsClosure
import ArakelovRH.Closure.WeilBoundToGRHClosure
import ArakelovRH.Closure.L_sym2_NonVanishingClosure
import ArakelovRH.Closure.ZetaZeroFreeClosure
import ArakelovRH.Closure.FunctionalEquationClosure
import ArakelovRH.Closure.ConverseUniquenessClosure
import ArakelovRH.Closure.SelbergWeilClosure

import ArakelovRH.SubClosure.CpowNormSubClosure
import ArakelovRH.SubClosure.GlobalRootNumberSubClosure
import ArakelovRH.SubClosure.PeterssonSubClosure
import ArakelovRH.SubClosure.DirichletAbsSubClosure
import ArakelovRH.SubClosure.GammaFactorSubClosure
import ArakelovRH.SubClosure.L143NonZeroSubClosure
import ArakelovRH.SubClosure.ZeroFreeStripSubClosure
import ArakelovRH.SubClosure.CremonaSubClosure

import ArakelovRH.SubClosure.ClosedSurfaces
import ArakelovRH.SubClosure.GlobalRootClose
import ArakelovRH.SubClosure.PhragmenLindelofSubClosure
import ArakelovRH.SubClosure.L_sym2_NonVanSubClosure
import ArakelovRH.SubClosure.WeilBoundSubClosure
