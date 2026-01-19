CREATE OR REPLACE VIEW public.bom_explosion_all_levels AS
SELECT 
    l0.plant,
    l0.year,
    

    l0.material AS fin_material_id,
    l0.release_type AS fin_material_release_type,
    l0.production_type AS fin_material_production_type,
    l0.quantity AS fin_production_quantity,
    

    l1.material AS prod_material_id,
    l1.release_type AS prod_material_release_type,
    l1.production_type AS prod_material_production_type,
    l1.quantity AS prod_material_production_quantity,
    

    l2.material AS component_id,
    l2.release_type AS component_material_release_type,
    l2.production_type AS component_material_production_type,
    l2.quantity AS component_consumption_quantity,
    

    l3.material AS level3_material_id,
    l3.release_type AS level3_material_release_type,
    l3.production_type AS level3_material_production_type,
    l3.quantity AS level3_material_quantity,
    

    l4.material AS level4_material_id,
    l4.release_type AS level4_material_release_type,
    l4.production_type AS level4_material_production_type,
    l4.quantity AS level4_material_quantity

FROM bom_data l0
LEFT JOIN bom_data l1 ON l1.plant = l0.plant AND l1.year = l0.year AND l1.material = l0.component
LEFT JOIN bom_data l2 ON l2.plant = l1.plant AND l2.year = l1.year AND l2.material = l1.component
LEFT JOIN bom_data l3 ON l3.plant = l2.plant AND l3.year = l2.year AND l3.material = l2.component
LEFT JOIN bom_data l4 ON l4.plant = l3.plant AND l4.year = l3.year AND l4.material = l3.component

WHERE l0.release_type = 'FIN'

ORDER BY l0.plant, l0.year, l0.material;
