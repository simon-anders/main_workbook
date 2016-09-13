library( readr )
library( dplyr )
library( tidyr )
library( reshape2 )
library( pheatmap )

tbl <- 
   read_csv( "~/work/AML_RNA/voom_cor_analysis_protein_coding.csv" ) %>%
   rename( ensg = X )

tbl <- tbl %>%
   mutate( adj.P.Val = p.adjust( P.Value, "BH" ) )

load( "~/work/AML_RNA/dg.rda" )

dgi <- 1  # index to dg; 6 is immunomodulators

sigGenes <- 
   tbl %>%
   inner_join( dg[[dgi]] ) %>%
   filter( adj.P.Val < .01 ) %>%
   distinct( ensg )
sigGenes

tbl %>%
   inner_join( dg[[dgi]] ) %>%
   inner_join( sigGenes ) %>%
   acast( Gene_name ~ Drug.name, value.var = "logFC" ) %>%
   pheatmap()
   
