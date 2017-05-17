# Daily Data


DailyData_StationName.csv  - contains daily summed data for each station

All variables in this file are expressed in the units of evapotranspiration (mm/day) unless otherwise indicated. All variables may not be included in the file for a particular station depending on sensors deployed for that particular station. For instance, only the full stations (D11, D12, D13) will have the eddy covariance and ground heat flux related variables.

### Misc. variables

* **stationName** – name of the ET station
*	**date** – day over which half-hourly measurements are summed
*	**ETo_mm** – daily reference evapotranspiration for the site provided by Spatial CIMIS

### Net Radiation related variables

*	**Rn_Avg_qc_mm** – daily sum of quality-controlled half-hourly net radiation
*	**Rn_Avg_gf_mm** – daily sum of gap-filled half-hourly net radiation
*	**Rn_Avg_qc_count** – number of half-hours summed in Rn_Avg_qc_mm (complete day = 48)
*	**Rn_Avg_gf_count** – number of half-hours summed in Rn_Avg_gf_mm (complete day = 48)
*	**Rn_Avg_qc_mm_Dqc** – Rn_Avg_qc_mm with incomplete days (count < 48) removed
*	**Rn_Avg_gf_mm_Dqc** – Rn_Avg_gf_mm with incomplete days (count < 48) removed
*	**Rn_Avg_gf_mm_Dgf** – Rn_Avg_gf_mm_Dqc with missing days gap-filled by linear interpolation

### Ground Heat Flux related variables

*	**G_qc_mm** – daily sum of quality-controlled half-hourly ground heat flux
*	**G_gf_mm** – daily sum of gap-filled half-hourly ground heat flux
*	**G_qc_count** – number of half-hours summed in G_qc_mm (complete day = 48)
*	**G_gf_count** – number of half-hours summed in G_gf_mm (complete day = 48)
*	**G_qc_mm_Dqc** – G_qc_mm with incomplete days (count < 48) removed
*	**G_gf_mm_Dqc** – G_gf_mm with incomplete days (count < 48) removed
*	**G_gf_mm_Dgf** – G_gf_mm_Dqc with missing days gap-filled with a value of 0 (assuming G on daily scale is negligible)

### Eddy Covariance Sensible Heat Flux related variables (including residual ET)

*	**H_ECrot_qc_mm** – daily sum of quality-controlled half-hourly eddy covariance sensible heat flux 
*	**H_ECrot _gf_mm** – daily sum of gap-filled half-hourly eddy covariance sensible heat flux
*	**H_ECrot _qc_count** – number of half-hours used in H_ECrot _qc_mm (complete day = 48)
*	**H_ECrot _gf_count** – number of half-hours used in H_ECrot _gf_mm (complete day = 48)
*	**H_ECrot _qc_mm_Dqc** – H_ECrot _qc_mm with incomplete days (count < 48) removed
*	**H_ECrot _gf_mm_Dqc** – H_ECrot _gf_mm with incomplete days (count < 48) removed 
*	**H_ECrot _gf_mm_Dgf** – H_ECrot _gf_mm_Dqc  with missing days gap-filled by linear interpolation
*	**ET_EC_qc** – actual daily evapotranspiration calculated from the sum of half-hourly quality controlled  ET calculated using eddy covariance sensible heat flux
*	**ET_EC_gf** –  actual daily evapotranspiration calculated from the sum of half-hourly gap filled  ET calculated using eddy covariance sensible heat flux
*	**ET_EC_qc_Dqc** – ET_EC_qc with incomplete days (count < 48) removed
*	**ET_EC_gf_Dqc** – ET_EC_gf with incomplete days (count < 48) removed
*	**ET_EC_qc_Dgf** – ET calculated as  Rn_Avg_gf_mm_Dqc - H_ECrot _gf_mm_Dqc - G_gf_mm_Dgf (uses of daily gap-filled G)
*	**ET_EC_gf_Dgf** – daily ET re-calculated using daily gap-filled components (Rn_Avg_gf_mm_Dgf  - H_ECrot _gf_mm_Dgf - G_gf_mm_Dgf ) 
*	**ET_EC_gf_Dgf2** – ET_EC_gf_Dgf with missing days gap-filled by linear interpolation
*	**Ka_EC** – Actual Daily ET (eddy covariance) divided by reference ET from Spatial CIMIS (Ka_SR =   ET_EC_qc_Dgf / ETo_mm) 


### Surface Renewal Sensible Heat Flux related variables (including residual ET)

#### Using only the first thermocouple (Tc)
*	**Tc_aH_qc_mm** – daily sum of quality-controlled half-hourly sensible heat flux derived from calibrated surface renewal using the first thermocouple (Tc)
*	**Tc_aH_gf_mm** – daily sum of gap-filled half-hourly sensible heat flux derived from calibrated surface renewal using the first thermocouple (Tc)
*	**Tc_aH_qc_count** – number of half-hours used in Tc_aH_qc_mm (complete day = 48)
*	**Tc_aH_gf_count** – number of half-hours used in Tc_aH_gf_mm (complete day = 48)
*	**Tc_aH_qc_mm_Dqc** – Tc_aH_qc_mm with incomplete days (count < 48) removed
*	**Tc_aH_gf_mm_Dqc** – Tc_aH_gf_mm with incomplete days (count < 48) removed 
*	**Tc_aH_gf_mm_Dgf** – Tc_aH_gf_mm_Dqc  with missing days gap-filled by linear interpolation
*	**ET_Tc_aH_qc** – actual daily evapotranspiration calculated from the residual of Rn_Avg_qc_mm, Tc_aH_qc_mm, and G_qc_mm (where available)
*	**ET_Tc_aH_gf** –  actual daily evapotranspiration calculated as the residual of Rn_Avg_gf_mm, Tc_aH_gf_mm, and G_gf_mm (where available)
*	**ET_Tc_aH_qc_Dqc** – ET_Tc_aH_qc with incomplete days (count < 48) removed
*	**ET_Tc_aH_gf_Dqc** – ET_Tc_aH_gf with incomplete days (count < 48) removed
*	**ET_Tc_qc_Dgf** – ET calculated as  Rn_Avg_gf_mm_Dqc - Tc_aH_gf_mm_Dqc - G_gf_mm_Dgf (uses daily gap-filled G)
*	**ET_Tc_aH_gf_Dgf** – daily ET re-calculated using daily gap-filled components (Rn_Avg_gf_mm_Dgf  - Tc_aH_gf_mm_Dgf - G_gf_mm_Dgf ) 
*	**ET_Tc_aH_gf_Dgf2** – ET_Tc_aH_gf_Dgf with missing days gap-filled by linear interpolation
*	**Ka_Tc** – Actual Daily ET (derived from Tc H measurement) divided by reference ET from Spatial CIMIS (Ka_Tc =   ET_Tc_aH_qc_Dgf/ ETo_mm) 

#### Using only the second thermocouple (Tn)

*	**Tn_aH_qc_mm** – daily sum of quality-controlled half-hourly sensible heat flux derived from calibrated surface renewal using the second thermocouple (Tn)
*	**Tn_aH_gf_mm** – daily sum of gap-filled half-hourly sensible heat flux derived from calibrated surface renewal using the second thermocouple (Tn)
*	**Tn_aH_qc_count** – number of half-hours used in Tn_aH_qc_mm (complete day = 48)
*	**Tn_aH_gf_count** – number of half-hours used in Tn_aH_gf_mm (complete day = 48)
*	**Tn_aH_qc_mm_Dqc** – Tn_aH_qc_mm with incomplete days (count < 48) removed
*	**Tn_aH_gf_mm_Dqc** – Tn_aH_gf_mm with incomplete days (count < 48) removed 
*	**Tn_aH_gf_mm_Dgf** – Tn_aH_gf_mm_Dqc  with missing days gap-filled by linear interpolation
*	**ET_Tn_aH_qc** – actual daily evapotranspiration calculated from the residual of Rn_Avg_qc_mm, Tn_aH_qc_mm, and G_qc_mm (where available)
*	**ET_Tn_aH_gf** –  actual daily evapotranspiration calculated from the residual of Rn_Avg_qc_mm, Tn_aH_qc_mm, and G_gf_mm (where available)
*	**ET_Tn_aH_qc_Dqc** – ET_Tn_aH_qc with incomplete days (count < 48) removed
*	**ET_Tn_aH_gf_Dqc** – ET_Tn_aH_gf with incomplete days (count < 48) removed
*	**ET_Tn_qc_Dgf** – ET calculated as  Rn_Avg_gf_mm_Dqc - Tn_aH_gf_mm_Dqc - G_gf_mm_Dgf (uses daily gap-filled G)
*	**ET_Tn_aH_gf_Dgf** – daily ET re-calculated using daily gap-filled components (Rn_Avg_gf_mm_Dgf  - Tn_aH_gf_mm_Dgf - G_gf_mm_Dgf) 
*	**ET_Tn_aH_gf_Dgf2** – ET_Tn_aH_gf_Dgf with missing days gap-filled by linear interpolation
*	**Ka_Tn** – Actual Daily ET (derived from Tn H measurement) divided by reference ET from Spatial CIMIS (Ka_Tn =   ET_Tn_aH_qc_Dgf/ ETo_mm) 

#### Using the sensible heat flux from both thermocouples (Tc and Tn)

*	**SR_aH_qc_mm** – daily sum of quality-controlled half-hourly sensible heat flux derived from calibrated surface renewal using an average of heat fluxes from both thermocouples
*	**SR_aH_gf_mm **– daily sum of gap-filled half-hourly sensible heat flux derived from calibrated surface renewal using an average of heat fluxes from both thermocouples
*	**SR_aH_qc_count** – number of half-hours used in SR_aH_qc_mm (complete day = 48)
*	**SR_aH_gf_count** – number of half-hours used in SR_aH_gf_mm (complete day = 48)
*	**SR_aH_qc_mm_Dqc** – SR_aH_qc_mm with incomplete days (count < 48) removed
*	**SR_aH_gf_mm_Dqc** – SR_aH_gf_mm with incomplete days (count < 48) removed 
*	**SR_aH_gf_mm_Dgf** – SR_aH_gf_mm_Dqc  with missing days gap-filled by linear interpolation
*	**ET_SR_aH_qc** – actual daily evapotranspiration calculated from the residual of Rn_Avg_qc_mm, SR_aH_qc_mm, and G_gf_mm (where available)
*	**ET_SR_aH_gf** –  actual daily evapotranspiration calculated from the residual of Rn_Avg_qc_mm, SR_aH_qc_mm, and G_gf_mm (where available)
*	**ET_SR_aH_qc_Dqc** – ET_SR_aH_qc with incomplete days (count < 48) removed
*	**ET_SR_aH_gf_Dqc** – ET_SR_aH_gf with incomplete days (count < 48) removed
*	**ET_SR_aH_qc_Dgf** – ET calculated as  Rn_Avg_gf_mm_Dqc - SR_aH_gf_mm_Dqc - G_gf_mm_Dgf (uses daily gap-filled G)
*	**ET_SR_aH_gf_Dgf** – daily ET re-calculated using daily gap-filled components (Rn_Avg_gf_mm_Dgf  - SR_aH_gf_mm_Dgf - G_gf_mm_Dgf) 
*	**ET_SR_aH_gf_Dgf2** – ET_SR_aH_gf_Dgf with missing days gap-filled by linear interpolation
*	**Ka_SR** – Actual Daily ET (derived from average of Tc and Tn  H measurements) divided by reference ET from Spatial CIMIS (Ka_SR =   ET_SR_aH_qc_Dgf / ETo_mm) 

 
















