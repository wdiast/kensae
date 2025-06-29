import os

# Ganti path ini sesuai folder tempat file geojson kamu
folder_path = 'assets/map/'

# Ambil semua file .geojson
files = [f for f in os.listdir(folder_path) if f.endswith('.geojson')]

# Urutkan biar rapi (opsional)
files.sort()

# Cetak dalam format YAML siap tempel
print('flutter:')
print('  assets:')
for f in files:
    print(f'    - {folder_path}{f}')
