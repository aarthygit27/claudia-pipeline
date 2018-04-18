import csv, os, json

SOURCE_DIR = "from_int"
NEW_PRODUCTS_DEST_DIR = os.path.join("Parsed_files", "new_products")
EXISTING_PRODUCTS_DEST_DIR = os.path.join("Parsed_files", "existing_products")

def write_data(filename, header, data, dest_dir):
    if not os.path.exists(dest_dir):
        os.makedirs(dest_dir)
    dest = os.path.join(dest_dir, filename)

    with open(dest, "wb") as f:
        writer = csv.writer(f)
        writer.writerow(header)
        for row in data:
            writer.writerow(row)


def get_ids(filename, i=0):
    data = []
    with open(filename + ".csv", "rb") as f:
        reader = csv.reader(f, delimiter=",", quotechar="\"")
        reader.next()   # skip the header
        for row in reader:
            data.append(row[i])
    return list(set(data))


def handle(filename, products, i, j=-1, source_dir=SOURCE_DIR, dest_dir=NEW_PRODUCTS_DEST_DIR):
    data = []
    lines = []
    with open(os.path.join(source_dir, filename + ".csv"), "rb") as f:
        reader = csv.reader(f, delimiter=",", quotechar="\"")
        header = reader.next()
        for row in reader:
            lines.append(row)
    for line in lines:
        if line[i] in products or (j!=-1 and line[j] in products): # reference ID to product
            data.append(line)
    write_data(filename + "2.csv", header, data, dest_dir)





###################################################################################################
### Functions to be called from main()
###################################################################################################

def write_files_from_products(filename, source_dir=SOURCE_DIR, dest_dir=NEW_PRODUCTS_DEST_DIR):
    solution_areas = get_ids(filename, 32) # TELIA_SUB_SOLUTION_AREA__C
    handle("mastersolutionarea", solution_areas, 0)

    offerings = get_ids(filename, 33)  # TELIA_CONTRACT_OFFERING_ID__C
    handle("offerings", offerings, 9)   # OFFERING_ID__C

    products = get_ids(filename)
    handle("attributeassignments", products, 48, source_dir=source_dir, dest_dir=dest_dir)    # VLOCITY_CMT__OBJECTID__C
    handle("productconfigurationprocedures", products, 13, source_dir=source_dir, dest_dir=dest_dir)  # VLOCITY_CMT__PRODUCTID__C
    handle("productchilditem", products, 9, 20, source_dir=source_dir, dest_dir=dest_dir)    # VLOCITY_CMT__CHILDPRODUCTID__C, VLOCITY_CMT__PARENTPRODUCTID__C
    handle("productrelationship", products, 20, 22, source_dir=source_dir, dest_dir=dest_dir)     # VLOCITY_CMT__PRODUCT2ID__C, VLOCITY_CMT__RELATEDPRODUCTID__C
    handle("pricebookentry", products, 3, source_dir=source_dir, dest_dir=dest_dir)   # PRODUCT2ID


def write_files_from_pricebook_entries(source_dir=SOURCE_DIR, dest_dir=NEW_PRODUCTS_DEST_DIR):
    pricebooks = get_ids(os.path.join(dest_dir, "pricebookentry2"), 2) # PRICEBOOK2ID
    handle("pricebook", pricebooks, 0, source_dir=source_dir, dest_dir=dest_dir)


def write_files_from_attribute_assignments(source_dir=SOURCE_DIR, dest_dir=NEW_PRODUCTS_DEST_DIR):
    attribute_categories = get_ids(os.path.join(dest_dir, "attributeassignments2"), 12) # VLOCITY_CMT__ATTRIBUTECATEGORYID__C
    handle("vlocityattributecategory", attribute_categories, 0, source_dir=source_dir, dest_dir=dest_dir)

    attributes = get_ids(os.path.join(dest_dir, "attributeassignments2"), 19) # VLOCITY_CMT__ATTRIBUTEID__C
    handle("vlocityattribute", attributes, 0, source_dir=source_dir, dest_dir=dest_dir)


def write_files_from_product_configuration_procedures(source_dir=SOURCE_DIR, dest_dir=NEW_PRODUCTS_DEST_DIR):
    entity_filters = get_ids(os.path.join(dest_dir, "productconfigurationprocedures2"), 12) # VLOCITY_CMT__ENTITYFILTERID__C
    handle("vlocityentityfilter", entity_filters, 0, source_dir=source_dir, dest_dir=dest_dir)
    handle("vlocityentityfiltercondition", entity_filters, 9, source_dir=source_dir, dest_dir=dest_dir)   # VLOCITY_CMT__ENTITYFILTERID__C
    handle("vlocityrulefilter", entity_filters, 9, source_dir=source_dir, dest_dir=dest_dir)   # VLOCITY_CMT__ENTITYFILTERID__C


def write_files_from_vlocity_rule_filters(source_dir=SOURCE_DIR, dest_dir=NEW_PRODUCTS_DEST_DIR):
    vlocity_rules = get_ids(os.path.join(dest_dir, "vlocityrulefilter2"), 8) # VLOCITY_CMT__RULEID__C
    handle("vlocityrule", vlocity_rules, 0, source_dir=source_dir, dest_dir=dest_dir)
    handle("vlocityruleaction", vlocity_rules, 8, source_dir=source_dir, dest_dir=dest_dir)   # VLOCITY_CMT__RULEID__C


###################################################################################################
### Main function
###################################################################################################

def main():
    write_files_from_products("products_new")
    # Rest of the files are written from files written by either products steps or later steps so filenames are not required
    write_files_from_pricebook_entries()
    write_files_from_attribute_assignments()
    write_files_from_product_configuration_procedures()
    

if __name__ == '__main__':
    main()