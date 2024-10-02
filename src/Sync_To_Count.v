module Sync_To_Count 
 #(parameter TOTAL_COLS = 800,   // Total de colonnes (incluant les porches)
   parameter TOTAL_ROWS = 525)   // Total de lignes (incluant les porches)
  (input            i_Clk,       // Horloge principale
   input            i_HSync,     // Signal de synchronisation horizontale
   input            i_VSync,     // Signal de synchronisation verticale
   output reg       o_HSync = 0, // Sortie pour synchronisation horizontale
   output reg       o_VSync = 0, // Sortie pour synchronisation verticale
   output reg [9:0] o_Col_Count = 0,  // Compteur de colonnes
   output reg [9:0] o_Row_Count = 0); // Compteur de lignes
   
   wire w_Frame_Start;  // Signal pour détecter le début d'une nouvelle frame
   
   // Registre de synchronisation pour aligner avec les données en sortie
   always @(posedge i_Clk)
   begin
     o_VSync <= i_VSync;
     o_HSync <= i_HSync;
   end

   // Suivre les compteurs de lignes et de colonnes
   always @(posedge i_Clk)
   begin
     if (w_Frame_Start == 1'b1)
     begin
       o_Col_Count <= 0;  // Réinitialisation du compteur de colonnes
       o_Row_Count <= 0;  // Réinitialisation du compteur de lignes
     end
     else
     begin
       if (o_Col_Count == TOTAL_COLS-1)  // Si on atteint la fin de la ligne
       begin
         if (o_Row_Count == TOTAL_ROWS-1)  // Si on atteint la fin de la frame
         begin
           o_Row_Count <= 0;  // Réinitialisation du compteur de lignes
         end
         else
         begin
           o_Row_Count <= o_Row_Count + 1;  // Incrémentation des lignes
         end
         o_Col_Count <= 0;  // Réinitialisation du compteur de colonnes
       end
       else
       begin
         o_Col_Count <= o_Col_Count + 1;  // Incrémentation des colonnes
       end
     end
   end

   // Détection de la montée du signal de synchronisation verticale pour réinitialiser les compteurs
   assign w_Frame_Start = (~o_VSync & i_VSync);

endmodule