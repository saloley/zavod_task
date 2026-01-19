import pandas as pd
import numpy as np

zavod_data = pd.read_csv("./data/task_2_data_ex.csv")

zavod_data = zavod_data.rename(columns={
    'plant_id': 'plant',
    'produced_material': 'material',
    'produced_material_production_type': 'production_type',
    'produced_material_release_type': 'release_type',
    'produced_material_quantity': 'quantity',
    'component_material': 'component',
    'component_material_production_type': 'component_production_type',
    'component_material_release_type': 'component_release_type',
    'component_material_quantity': 'component_quantity'
})

zavod_data['release_type'] = zavod_data['release_type'].str.upper().str.strip()
zavod_data['component_release_type'] = zavod_data['component_release_type'].fillna('').str.upper().str.strip()




zavod_data['quantity'] = zavod_data['quantity'].astype(str).str.replace(',', '').str.strip()
zavod_data['quantity'] = pd.to_numeric(zavod_data['quantity'], errors='coerce')

zavod_data['component_quantity'] = zavod_data['component_quantity'].astype(str).str.replace(',', '').str.strip()
zavod_data['component_quantity'] = pd.to_numeric(zavod_data['component_quantity'], errors='coerce')


zavod_data['component'] = zavod_data['component'].fillna(0).astype(int)
zavod_data['component_production_type'] = zavod_data['component_production_type'].fillna(0).astype(int)


fin = zavod_data[zavod_data['release_type'] == 'FIN'].copy()
fin = fin.add_suffix('_fin')

print(f"  Уровень 0 (FIN): {len(fin)} материалов")

if len(fin) == 0:
    exit(1)


prod = zavod_data.copy()
prod = prod.add_suffix('_prod')


result = fin.merge(
    prod,
    left_on=['plant_fin', 'year_fin', 'component_fin'],
    right_on=['plant_prod', 'year_prod', 'material_prod'],
    how='inner'
)


comp = zavod_data.copy()
comp = comp.add_suffix('_comp')


result = result.merge(
    comp,
    left_on=['plant_prod', 'year_prod', 'component_prod'],
    right_on=['plant_comp', 'year_comp', 'material_comp'],
    how='left'
)

explosion = pd.DataFrame({

    'plant': result['plant_fin'],
    'year': result['year_fin'],
    'fin_material_id': result['material_fin'].astype(int),
    'fin_material_release_type': result['release_type_fin'],
    'fin_material_production_type': result['production_type_fin'].astype(int),
    'fin_production_quantity': result['quantity_fin'],
    'prod_material_id': result['material_prod'].astype(int),
    'prod_material_release_type': result['release_type_prod'],
    'prod_material_production_type': result['production_type_prod'].astype(int),
    'prod_material_production_quantity': result['quantity_prod'],
    'component_id': result['component_prod'].astype(int),
    'component_material_release_type': result['component_release_type_prod'],
    'component_material_production_type': result['component_production_type_prod'],
    'component_consumption_quantity': result['component_quantity_prod']
})


explosion = explosion.sort_values(
    ['plant', 'year', 'fin_material_id', 'prod_material_id']
).reset_index(drop=True)

plant_stats = explosion.groupby('plant').agg({
    'fin_material_id': 'nunique',
    'prod_material_id': 'nunique',
    'component_id': 'nunique'
}).rename(columns={
    'fin_material_id': 'FIN_count',
    'prod_material_id': 'PROD_count',
    'component_id': 'Component_count'
})
print(plant_stats.to_string())

year_stats = explosion.groupby('year').size()
print(year_stats.to_string())

print(f"\nРаспределение PROD по release_type:")
print(explosion['prod_material_release_type'].value_counts())

print(f"\nРаспределение Component по release_type:")
print(explosion['component_material_release_type'].value_counts())
explosion.head()