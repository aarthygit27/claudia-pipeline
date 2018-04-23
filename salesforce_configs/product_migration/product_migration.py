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
    print filename[:-5], "-", len(data)


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


def append_to_file(filename, source_dir=EXISTING_PRODUCTS_DEST_DIR, dest_dir=EXISTING_PRODUCTS_DEST_DIR):
    # Read two files from source_dir and source_dir/hashed. Compare the IDs and add only unique ID rows
    # to be written into the file. Finally rewrite source_dir/filename (by default. You may also write the
    # file to a new location).
    lines = []
    with open(os.path.join(source_dir, filename + ".csv"), "rb") as f:
        reader = csv.reader(f, delimiter=",", quotechar="\"")
        header = reader.next()
        for row in reader:
            lines.append(row)
    i = [x[0] for x in lines]
    with open(os.path.join(source_dir, "hashed", filename + ".csv"), "rb") as f:
        reader = csv.reader(f, delimiter=",", quotechar="\"")
        header = reader.next()
        for row in reader:
            if row[0] not in i:
                lines.append(row)
    write_data(filename + ".csv", header, lines, dest_dir)


###################################################################################################
### Functions to be called from main()
###################################################################################################

def write_files_from_products(filename, source_dir=SOURCE_DIR, dest_dir=NEW_PRODUCTS_DEST_DIR):
    solution_areas = get_ids(filename, 32) # TELIA_SUB_SOLUTION_AREA__C
    handle("mastersolutionarea", solution_areas, 0, source_dir=source_dir, dest_dir=dest_dir)

    offerings = get_ids(filename, 33)  # TELIA_CONTRACT_OFFERING_ID__C
    handle("offerings", offerings, 9, source_dir=source_dir, dest_dir=dest_dir)   # OFFERING_ID__C

    products = get_ids(filename)
    handle("attributeassignments", products, 48, source_dir=source_dir, dest_dir=dest_dir)    # VLOCITY_CMT__OBJECTID__C
    handle("productconfigurationprocedures", products, 13, source_dir=source_dir, dest_dir=dest_dir)  # VLOCITY_CMT__PRODUCTID__C
    handle("productchilditem", products, 9, 20, source_dir=source_dir, dest_dir=dest_dir)    # VLOCITY_CMT__CHILDPRODUCTID__C, VLOCITY_CMT__PARENTPRODUCTID__C
    handle("productrelationship", products, 20, 22, source_dir=source_dir, dest_dir=dest_dir)     # VLOCITY_CMT__PRODUCT2ID__C, VLOCITY_CMT__RELATEDPRODUCTID__C
    handle("pricebookentry", products, 3, source_dir=source_dir, dest_dir=dest_dir)   # PRODUCT2ID

    pricebooks = get_ids(os.path.join(dest_dir, "pricebookentry2"), 2) # PRICEBOOK2ID
    handle("pricebook", pricebooks, 0, source_dir=source_dir, dest_dir=dest_dir)

    attribute_categories = get_ids(os.path.join(dest_dir, "attributeassignments2"), 12) # VLOCITY_CMT__ATTRIBUTECATEGORYID__C
    handle("vlocityattributecategory", attribute_categories, 0, source_dir=source_dir, dest_dir=dest_dir)

    attributes = get_ids(os.path.join(dest_dir, "attributeassignments2"), 19) # VLOCITY_CMT__ATTRIBUTEID__C
    handle("vlocityattribute", attributes, 0, source_dir=source_dir, dest_dir=dest_dir)

    entity_filters = get_ids(os.path.join(dest_dir, "productconfigurationprocedures2"), 12) # VLOCITY_CMT__ENTITYFILTERID__C
    handle("vlocityentityfilter", entity_filters, 0, source_dir=source_dir, dest_dir=dest_dir)
    handle("vlocityentityfiltercondition", entity_filters, 9, source_dir=source_dir, dest_dir=dest_dir)   # VLOCITY_CMT__ENTITYFILTERID__C
    handle("vlocityrulefilter", entity_filters, 9, source_dir=source_dir, dest_dir=dest_dir)   # VLOCITY_CMT__ENTITYFILTERID__C

    vlocity_rules = get_ids(os.path.join(dest_dir, "vlocityrulefilter2"), 8) # VLOCITY_CMT__RULEID__C
    handle("vlocityrule", vlocity_rules, 0, source_dir=source_dir, dest_dir=dest_dir)
    handle("vlocityruleaction", vlocity_rules, 8, source_dir=source_dir, dest_dir=dest_dir)   # VLOCITY_CMT__RULEID__C


def write_hashed_products_file(source_products, target_products):
    source = []
    with open(source_products + ".csv", "rb") as f:
        reader = csv.reader(f, delimiter=",", quotechar="\"")
        header = reader.next()   # skip the header
        for row in reader:
            source.append(row)
    target = []
    with open(target_products + ".csv", "rb") as f:
        reader = csv.reader(f, delimiter=",", quotechar="\"")
        reader.next()   # skip the header
        for row in reader:
            target.append(row)

    for product in source:
        h = product[56]    # PRODUCT_HASH__C
        for product2 in target:
            if h == product2[56]:   # PRODUCT_HASH__C
                product[0] = product2[0]    # Replace source Ids with target Ids
                break
    write_data("products_hashed.csv", header, source, ".")  # Write file to current folder


def append_hashed_products_to_existing_products():
    append_to_file("attributeassignments2")
    append_to_file("mastersolutionarea2")
    append_to_file("offerings2")
    append_to_file("pricebook2")
    append_to_file("pricebookentry2")
    append_to_file("productchilditem2")
    append_to_file("productconfigurationprocedures2")
    append_to_file("productrelationship2")
    append_to_file("vlocityattribute2")
    append_to_file("vlocityattributecategory2")
    append_to_file("vlocityentityfilter2")
    append_to_file("vlocityentityfiltercondition2")
    append_to_file("vlocityrule2")
    append_to_file("vlocityruleaction2")
    append_to_file("vlocityrulefilter2")


###################################################################################################
### Main function
###################################################################################################

def main():
    # NEW PRODUCTS
    print "--- NEW PRODUCTS ---"
    write_files_from_products("products_new")

    # EXISTING PRODUCTS
    print "--- EXISTING PRODUCTS ---"
    write_files_from_products("products_existing", dest_dir=EXISTING_PRODUCTS_DEST_DIR)
    print "-------------------------"
    write_hashed_products_file("products_existing", "products_preprod")
    print "-------------------------"
    write_files_from_products("products_hashed", "from_preprod", os.path.join(EXISTING_PRODUCTS_DEST_DIR, "hashed"))
    print "--- EXISTING PRODUCTS AFTER ADDING HASHED VALUES ---"
    append_hashed_products_to_existing_products()




if __name__ == '__main__':
    main()