# Product migration

1. Use Data Loader to get all necessary files from source and target environments. Name the extracts as they are in Data Loader without capital letters or spaces and in csv format (e.g. Product Configuration Procedures --> productconfigurationprocedures.csv). Place the source environment files to `from_int` folder and target environment files to `from_preprod` folder.
2. Split products files to new products and products that already exists in the target environment. Name the files `products_new.csv` and `products_existing.csv`.
3. Name the product file from the target environment `products_preprod.csv`.
4. Run `python product_migration.py`.
5. Use Data Loader to load the data to target environment according to the instructions in the product deployment guide.