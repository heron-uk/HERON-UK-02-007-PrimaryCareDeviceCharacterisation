
# device snomed
# Codelist derivation: Standard community silver wound dressings (dm+d / SNOMED CT)
# - from two NHSBSA sources to ensure full active and historical coverage:
#     1. NHS dm+d XML release (DuckDB): captures silver-specific VMPs and linked AMPs
#        (including products whose brand names omit "silver"/"Ag", e.g., Acticoat, Promogran Prisma,
#        and discontinued historical concepts).
#     2. NHSBSA BNF-to-SNOMED mapping (BNF Chapter 20: Dressings): captures active silver AMPs
#        mapped under non-silver generic VMPs (e.g., Mepilex Ag, Melgisorb Ag, Exufiber Ag+).
# - Excludes non-dressing silver items (creams, caustic pencils, catheters), non-sheet formats
#   (sprays, pastes, hydrogels), and specialist/non-wound devices (NPWT kits, IV exit discs,
#   laryngectomy filters, blood glucose test strips).
# - Deduplicated by SNOMED CT / dm+d identifier and mapped to OMOP standard concept_ids.

# export codelists


