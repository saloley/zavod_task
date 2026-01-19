CREATE OR REPLACE FUNCTION public.get_bom_explosion(
    p_plant VARCHAR DEFAULT NULL,
    p_year INTEGER DEFAULT NULL,
    p_fin_material VARCHAR DEFAULT NULL
)
RETURNS TABLE (
    plant VARCHAR,
    year INTEGER,
    fin_material_id VARCHAR,
    fin_material_release_type VARCHAR,
    fin_material_production_type VARCHAR,
    fin_production_quantity NUMERIC,
    prod_material_id VARCHAR,
    prod_material_release_type VARCHAR,
    prod_material_production_type VARCHAR,
    prod_material_production_quantity NUMERIC,
    component_id VARCHAR,
    component_material_release_type VARCHAR,
    component_material_production_type VARCHAR,
    component_consumption_quantity NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.plant,
        e.year,
        e.fin_material_id,
        e.fin_material_release_type,
        e.fin_material_production_type,
        e.fin_production_quantity,
        e.prod_material_id,
        e.prod_material_release_type,
        e.prod_material_production_type,
        e.prod_material_production_quantity,
        e.component_id,
        e.component_material_release_type,
        e.component_material_production_type,
        e.component_consumption_quantity
    FROM bom_explosion e
    WHERE 
        (p_plant IS NULL OR e.plant = p_plant)
        AND (p_year IS NULL OR e.year = p_year)
        AND (p_fin_material IS NULL OR e.fin_material_id = p_fin_material);
END;
$$ LANGUAGE plpgsql;