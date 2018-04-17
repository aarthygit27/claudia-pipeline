import csv, os, json

DEST_DIR = os.path.join("Parsed_files", "new_products")

def write_data(filename, header, data):
    if not os.path.exists(DEST_DIR):
        os.makedirs(DEST_DIR)
    dest = os.path.join(DEST_DIR, filename)

    with open(dest, "wb") as f:
        writer = csv.writer(f)
        writer.writerow(header)
        for row in data:
            writer.writerow(row)


def get_ids(filename, i=0):
    data = []
    with open(filename + ".csv" , "rb") as f:
        reader = csv.reader(f, delimiter=",", quotechar="\"")
        for row in reader:
            data.append(row[i])
    return list(set(data))

def handle(filename, products, i, j=-1):
    data = []
    lines = []
    with open(filename + ".csv" , "rb") as f:
        reader = csv.reader(f, delimiter=",", quotechar="\"")
        for row in reader:
            lines.append(row)
    header = lines.pop(0)   # Remove header from lines
    for line in lines:
        if line[i] in products or (j!=-1 and line[j] in products): # reference ID to product
            data.append(line)

    write_data(filename + "2.csv", header, data)

def main():
    solution_areas = get_ids("products_new", 32) # TELIA_SUB_SOLUTION_AREA__C
    handle("mastersolutionarea", solution_areas, 0)

    offerings = get_ids("products_new", 33)  # TELIA_CONTRACT_OFFERING_ID__C
    handle("offerings", offerings, 9)   # OFFERING_ID__C

    products = get_ids("products_new")
    handle("attributeassignments", products, 48)    # VLOCITY_CMT__OBJECTID__C
    handle("productconfigurationprocedures", products, 13)  # VLOCITY_CMT__PRODUCTID__C
    handle("productchilditem", products, 9, 20)    # VLOCITY_CMT__CHILDPRODUCTID__C, VLOCITY_CMT__PARENTPRODUCTID__C
    handle("productrelationship", products, 20, 22)     # VLOCITY_CMT__PRODUCT2ID__C, VLOCITY_CMT__RELATEDPRODUCTID__C

    # Pricebookentry must be done before Pricebook
    handle("pricebookentry", products, 3)   # PRODUCT2ID
    pricebooks = get_ids(os.path.join(DEST_DIR, "pricebookentry2"), 2)
    handle("pricebook", pricebooks, 0)

    attribute_categories = get_ids(os.path.join(DEST_DIR, "attributeassignments2"), 12) # VLOCITY_CMT__ATTRIBUTECATEGORYID__C
    handle("vlocityattributecategory", attribute_categories, 0)

    attributes = get_ids(os.path.join(DEST_DIR, "attributeassignments2"), 19) # VLOCITY_CMT__ATTRIBUTEID__C
    handle("vlocityattribute", attributes, 0)

    entity_filters = get_ids(os.path.join(DEST_DIR, "productconfigurationprocedures2"), 12) # VLOCITY_CMT__ENTITYFILTERID__C
    handle("vlocityentityfilter", entity_filters, 0)


if __name__ == '__main__':
    main()