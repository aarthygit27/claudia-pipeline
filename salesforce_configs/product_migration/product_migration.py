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

def handle(filename, products, i, ignore_json=False):
    data = []
    lines = []
    with open(filename + ".csv" , "rb") as f:
        reader = csv.reader(f, delimiter=",", quotechar="\"")
        for row in reader:
            lines.append(row)
    header = lines.pop(0)   # Remove header from lines
    for line in lines:
        if line[i] in products: # reference ID to product
            data.append(line)

    write_data(filename + "2.csv", header, data)

def handle2(filename, products, i, j):
    data = []

    with open(filename + ".csv" , "rb") as f:
        reader = csv.reader(f, delimiter=",", quotechar="\"")
        first = True
        header = ""
        for row in reader:
            if first:  # header row. Could be done more elegantly
                header = row
            first = False
            if row[i] in products or row[j] in products: # reference ID to product
                data.append(row)

    write_data(filename + "2.csv", header, data)


def main():
    solution_areas = get_ids("products_new", 32) # TELIA_SUB_SOLUTION_AREA__C
    handle("mastersolutionarea", solution_areas, 0)

    offerings = get_ids("products_new", 33)  # TELIA_CONTRACT_OFFERING_ID__C
    handle("offerings", offerings, 9)   # OFFERING_ID__C

    products = get_ids("products_new")
    handle("attributeassignments", products, 48)    # VLOCITY_CMT__OBJECTID__C
    handle("productconfigurationprocedures", products, 13)  # VLOCITY_CMT__PRODUCTID__C
    handle2("productchilditem", products, 9, 20)    # VLOCITY_CMT__CHILDPRODUCTID__C, VLOCITY_CMT__PARENTPRODUCTID__C
    handle2("productrelationship", products, 20, 22)     # VLOCITY_CMT__PRODUCT2ID__C, VLOCITY_CMT__RELATEDPRODUCTID__C

    # Pricebookentry must be done before Pricebook
    handle("pricebookentry", products, 3)   # PRODUCT2ID
    pricebooks = get_ids(os.path.join(DEST_DIR, "pricebookentry2"), 2)
    handle("pricebook", pricebooks, 0)

    attribute_categories = get_ids(os.path.join(DEST_DIR, "attributeassignments2"), 12) # VLOCITY_CMT__ATTRIBUTECATEGORYID__C
    # attribute_categories = ["a0F3E000002h1k2UAA", "a0F3E000002h1jxUAA", "a0F5800000EVOe9EAH", "a0F5800000EVOe7EAH", "a0F5800000EVOeAEAX"]
    # print attribute_categories
    handle("vlocityattributecategory", attribute_categories, 0)

    attributes = get_ids(os.path.join(DEST_DIR, "attributeassignments2"), 19) # VLOCITY_CMT__ATTRIBUTEID__C
    print attributes
    # attributes = ['a0G5800000hmmNGEAY', 'a0G5800000hmmOnEAI', 'a0G3E0000031UIFUA2', 'a0G5800000hmmOpEAI', 'a0G5800000hmmR2EAI', 'a0G3E0000031UIAUA2', 'a0G5800000hmmPnEAI', 'a0G5800000hmmOEEAY', 'a0G5800000hmmR8EAI', 'a0G5800000hmmR3EAI', 'a0G5800000hmmP3EAI', 'a0G3E0000031UJ0UAM', 'a0G5800000hmmRHEAY', 'a0G5800000hmmQrEAI', 'a0G5800000hmmQuEAI', 'a0G3E0000031UIOUA2', 'a0G5800000hmmPtEAI', 'a0G3E0000031UI8UAM', 'a0G5800000hmmPjEAI', 'a0G5800000hmmPNEAY', 'a0G5800000hmmQdEAI', 'a0G5800000hmmOsEAI', 'a0G3E0000031UJ8UAM', 'a0G3E0000031UIkUAM', 'a0G3E0000031UIvUAM', 'a0G5800000hmmRAEAY', 'a0G5800000hmmNiEAI', 'a0G5800000hmmPlEAI', 'a0G5800000hmmPcEAI', 'a0G3E0000031UILUA2', 'a0G5800000hmmQbEAI', 'a0G5800000hmmOvEAI', 'a0G5800000hmmN3EAI', 'a0G5800000hmmOeEAI', 'a0G5800000hmmO8EAI', 'a0G5800000hmmRJEAY', 'a0G5800000hmmQNEAY', 'a0G3E0000031UI9UAM', 'a0G3E0000031UI2UAM', 'a0G3E0000031UJ2UAM', 'a0G5800000hmmQwEAI', 'a0G3E0000031UIxUAM', 'a0G3E0000031UJ3UAM', 'a0G3E0000031UIcUAM', 'a0G3E0000031UJ5UAM', 'a0G5800000hmmQMEAY', 'a0G3E0000031UJGUA2', 'a0G3E0000031UINUA2', 'a0G3E0000031UI1UAM', 'a0G5800000hmmRMEAY', 'a0G5800000hmmR1EAI', 'a0G5800000hmmQKEAY', 'a0G5800000hmmO5EAI', 'a0G5800000hmmP2EAI', 'a0G3E0000031UIJUA2', 'a0G5800000hmmQQEAY', 'a0G3E0000031UIHUA2', 'a0G3E0000031UIDUA2', 'a0G3E0000031UIBUA2', 'a0G3E0000031UIQUA2', 'a0G5800000hmmQoEAI', 'a0G5800000hmmODEAY', 'a0G5800000hmmQpEAI', 'a0G5800000hmmQzEAI', 'a0G5800000hmmNnEAI', 'a0G5800000hmmNHEAY', 'a0G5800000hmmPfEAI', 'a0G3E0000031UIyUAM', 'a0G3E0000031UJ4UAM', 'a0G5800000hmmQlEAI', 'a0G5800000hmmPBEAY', 'a0G3E0000031UIrUAM', 'a0G5800000hmmPWEAY', 'a0G5800000hmmPUEAY', 'a0G5800000hmmOmEAI', 'a0G3E0000031UIiUAM', 'a0G5800000hmmNsEAI', 'a0G5800000hmmPhEAI', 'a0G3E0000031UIqUAM', 'a0G3E0000031UIbUAM', 'a0G5800000hmmQtEAI', 'a0G5800000hmmQUEAY', 'a0G5800000hmmQvEAI', 'a0G5800000hmmObEAI', 'a0G5800000hmmRBEAY', 'a0G3E0000031UJHUA2', 'a0G5800000hmmN2EAI', 'a0G5800000hmmQhEAI', 'a0G5800000hmmNZEAY', 'a0G5800000hmmP5EAI', 'a0G3E0000031UJBUA2', 'a0G5800000hmmQnEAI', 'a0G5800000hmmOZEAY', 'a0G5800000hmmN8EAI', 'a0G5800000hmmQeEAI', 'a0G5800000hmmNuEAI', 'a0G3E0000031UITUA2', 'a0G5800000hmmPqEAI', 'a0G5800000hmmQTEAY', 'a0G5800000hmmPvEAI', 'a0G5800000hmmR0EAI', 'a0G5800000hmmPQEAY', 'a0G3E0000031UI6UAM', 'a0G5800000hmmQWEAY', 'a0G5800000hmmQYEAY', 'a0G3E0000031UJ9UAM', 'a0G5800000hmmQqEAI', 'a0G5800000hmmQBEAY', 'a0G5800000hmmRNEAY', 'a0G3E0000031UIKUA2', 'a0G5800000hmmNqEAI', 'a0G5800000hmmO4EAI', 'a0G5800000hmmR6EAI', 'a0G3E0000031UJDUA2', 'a0G5800000hmmNLEAY', 'a0G5800000hmmQCEAY', 'a0G3E0000031UIuUAM', 'a0G3E0000031UIEUA2', 'a0G3E0000031UIsUAM', 'a0G5800000hmmPoEAI', 'a0G3E0000031UI7UAM', 'a0G3E0000031UISUA2', 'a0G3E0000031UIYUA2', 'a0G5800000hmmRCEAY', 'a0G5800000hmmOqEAI', 'a0G3E0000031UJIUA2', 'a0G5800000hmmONEAY', 'a0G5800000hmmQREAY', 'a0G5800000hmmQ5EAI', 'a0G5800000hmmQ0EAI', 'a0G5800000hmmOCEAY', 'a0G5800000hmmQfEAI', 'a0G5800000hmmPHEAY', 'a0G5800000hmmQmEAI', 'a0G3E0000031UIaUAM', 'a0G5800000hmmRKEAY', 'a0G3E0000031UJCUA2', 'a0G3E0000031UJAUA2', 'a0G5800000hmmPkEAI', 'a0G3E0000031UJ6UAM', 'a0G3E0000031UIMUA2', 'a0G5800000hmmOKEAY', 'a0G3E0000031UICUA2', 'a0G3E0000031UIXUA2', 'a0G5800000hmmREEAY', 'a0G3E0000031UIwUAM', 'a0G5800000hmmQ2EAI', 'a0G5800000hmmPgEAI', 'a0G5800000hmmOoEAI', 'a0G5800000hmmOBEAY', 'a0G5800000hmmN4EAI', 'a0G5800000hmmPbEAI', 'a0G5800000hmmOHEAY', 'a0G5800000hmmPVEAY', 'a0G5800000hmmQxEAI', 'a0G3E0000031UIlUAM', 'a0G3E0000031UIpUAM', 'a0G5800000hmmQcEAI', 'a0G5800000hmmRGEAY', 'a0G5800000hmmR4EAI', 'a0G5800000hmmQDEAY', 'a0G5800000hmmNREAY', 'a0G5800000hmmR9EAI', 'a0G3E0000031UIIUA2', 'a0G5800000hmmQZEAY', 'a0G5800000hmmR5EAI', 'a0G5800000hmmR7EAI', 'a0G3E0000031UI4UAM', 'a0G3E0000031UIeUAM', 'a0G5800000hmmPIEAY', 'a0G5800000hmmRDEAY', 'a0G3E0000031UItUAM', 'a0G3E0000031UIgUAM', 'a0G5800000hmmQOEAY', 'a0G5800000hmmQaEAI', 'a0G5800000hmmNmEAI', 'a0G5800000hmmQjEAI', 'a0G3E0000031UIPUA2', 'a0G3E0000031UJ7UAM', 'a0G5800000hmmNBEAY', 'a0G5800000hmmQPEAY', 'a0G5800000hmmPrEAI', 'a0G5800000hmmRLEAY', 'a0G3E0000031UIfUAM', 'a0G5800000hmmQsEAI', 'a0G5800000hmmNdEAI', 'a0G5800000hmmPmEAI', 'a0G5800000hmmRFEAY', 'a0G5800000hmmRIEAY', 'a0G5800000hmmQXEAY', 'a0G3E0000031UI5UAM', 'a0G5800000hmmQkEAI', 'a0G3E0000031UI3UAM', 'a0G3E0000031UIWUA2', 'a0G3E0000031UJFUA2', 'a0G5800000hmmP4EAI', 'a0G5800000hmmQyEAI', 'a0G5800000hmmNvEAI', 'a0G5800000hmmQiEAI', 'a0G3E0000031UImUAM']
    # print attributes
    handle("vlocityattribute", attributes, 0)

    entity_filters = get_ids(os.path.join(DEST_DIR, "productconfigurationprocedures2"), 12) # VLOCITY_CMT__ENTITYFILTERID__C
    # entity_filters = ['a1E58000003DRJ0EAO', 'a1E3E000003GRuJUAW', 'a1E3E000003GRttUAG', 'a1E58000003DRJHEA4', 'a1E3E000003GRx2UAG', 'a1E58000003DRIFEA4', 'a1E58000003DRITEA4', 'a1E58000003DRISEA4', 'a1E3E000003GRxXUAW', 'a1E3E000003GRxWUAW', 'a1E3E000003GRvGUAW', 'a1E58000003DRGgEAO', 'a1E58000003DRHjEAO', 'a1E3E000003GRuiUAG', 'a1E3E000003GRtYUAW', 'a1E3E000003GRugUAG', 'a1E3E000003GRwNUAW', 'a1E58000003DRHAEA4', 'a1E3E000003GRvJUAW', 'a1E58000003DRJFEA4', 'a1E58000003DRHpEAO', 'a1E58000003DRI1EAO', 'a1E58000003DRHaEAO', 'a1E3E000003GRvgUAG', 'a1E3E000003GRveUAG', 'a1E58000003DRIgEAO', 'a1E58000003DRIyEAO', 'a1E3E000003GRvQUAW', 'a1E3E000003GRvoUAG', 'a1E3E000003GRvjUAG', 'a1E58000003DRIHEA4', 'a1E3E000003GRtlUAG', 'a1E3E000003GRviUAG', 'a1E58000003DRGXEA4', 'a1E3E000003GRvrUAG', 'a1E58000003DRHDEA4', 'a1E58000003DRI7EAO', 'a1E3E000003GRtfUAG', 'a1E58000003DRI2EAO', 'a1E3E000003GRtsUAG', 'a1E3E000003GRtaUAG', 'a1E58000003DRGvEAO', 'a1E58000003DRIMEA4', 'a1E58000003DRI5EAO', 'a1E58000003DRIzEAO', 'a1E3E000003GRv0UAG', 'a1E58000003DRHCEA4', 'a1E3E000003GRuwUAG', 'a1E58000003DRJ2EAO', 'a1E58000003DRI8EAO', 'a1E3E000003GRtWUAW', 'a1E3E000003GRv8UAG', 'a1E58000003DRHiEAO', 'a1E58000003DRHqEAO', 'a1E58000003DRHLEA4', 'a1E58000003DRI4EAO', 'a1E58000003DRJJEA4', 'a1E58000003DRICEA4', 'a1E3E000003GRuaUAG', 'a1E58000003DRIqEAO', 'a1E3E000003GRt9UAG', 'a1E58000003DRHEEA4', 'a1E58000003DRIWEA4', 'a1E58000003DRHGEA4', 'a1E3E000003GRr9UAG', 'a1E3E000003GRwOUAW', 'a1E3E000003GRuzUAG', 'a1E58000003DRHSEA4', 'a1E3E000003GRvaUAG', 'a1E58000003DRJ8EAO', 'a1E58000003DRJCEA4', 'a1E58000003DRJLEA4', 'a1E58000003DRH1EAO', 'a1E58000003DRHREA4', 'a1E3E000003GRvBUAW', 'a1E58000003DRH8EAO', 'a1E3E000003GRtiUAG', 'a1E3E000003GRxRUAW', 'a1E3E000003GRxAUAW', 'a1E3E000003GRxDUAW', 'a1E3E000003GRvXUAW', 'a1E58000003DRJ9EAO', 'a1E3E000003GRxGUAW', 'a1E58000003DRHBEA4', 'a1E3E000003GRvbUAG', 'a1E58000003DRIhEAO', 'a1E58000003DRIlEAO', 'a1E3E000003GRrbUAG', 'a1E58000003DRHPEA4', 'a1E58000003DRIBEA4', 'a1E3E000003GRtBUAW', 'a1E3E000003GRv1UAG', 'a1E58000003DRIoEAO', 'a1E3E000003GRtnUAG', 'a1E58000003DRIwEAO', 'a1E58000003DRIXEA4', 'a1E58000003DRGYEA4', 'a1E58000003DRItEAO', 'a1E3E000003GRuxUAG', 'a1E58000003DRIUEA4', 'a1E3E000003GRwVUAW', 'a1E3E000003GRvhUAG', 'a1E3E000003GRrGUAW', 'a1E3E000003GRrZUAW', 'a1E3E000003GRtmUAG', 'a1E3E000003GRtoUAG', 'a1E58000003DRHKEA4', 'a1E3E000003GRroUAG', 'a1E3E000003GRteUAG', 'a1E58000003DRHXEA4', 'a1E3E000003GRuAUAW', 'a1E3E000003GRv2UAG', 'a1E3E000003GRtcUAG', 'a1E58000003DRGqEAO', 'a1E58000003DRGbEAO', 'a1E58000003DRJIEA4', 'a1E58000003DRIuEAO', 'a1E3E000003GRujUAG', 'a1E58000003DRHfEAO', 'a1E3E000003GRxQUAW', 'a1E58000003DRHgEAO', 'a1E3E000003GRvMUAW', 'a1E58000003DRHsEAO', 'a1E58000003DRHHEA4', 'a1E58000003DRHuEAO', 'a1E3E000003GRuyUAG', 'a1E58000003DRHvEAO', 'a1E58000003DRI6EAO', 'a1E58000003DRHMEA4', 'a1E3E000003GRtgUAG', 'a1E3E000003GRuqUAG', 'a1E3E000003GRuBUAW', 'a1E58000003DRHoEAO', 'a1E58000003DRIrEAO', 'a1E3E000003GRtjUAG', 'a1E3E000003GRtdUAG', 'a1E3E000003GRvqUAG', 'a1E58000003DRImEAO', 'a1E3E000003GRx3UAG', 'a1E3E000003GRwTUAW', 'a1E58000003DRIDEA4', 'a1E58000003DRI3EAO', 'a1E58000003DRJMEA4', 'a1E3E000003GRshUAG', 'a1E3E000003GRtkUAG', 'a1E58000003DRHJEA4', 'a1E58000003DRHQEA4', 'a1E58000003DRGtEAO', 'a1E3E000003GRvHUAW', 'a1E58000003DRHWEA4', 'a1E58000003DRIvEAO', 'a1E58000003DRJ6EAO', 'a1E3E000003GRtZUAW', 'a1E58000003DRGoEAO', 'a1E58000003DRGlEAO', 'a1E58000003DRJBEA4', 'a1E3E000003GRthUAG', 'a1E3E000003GRvpUAG', 'a1E58000003DRH6EAO', 'a1E58000003DRH9EAO', 'a1E58000003DRH5EAO', 'a1E3E000003GRvKUAW', 'a1E58000003DRIaEAO', 'a1E3E000003GRtqUAG', 'a1E58000003DRIsEAO', 'a1E58000003DRIeEAO', 'a1E58000003DRJ1EAO', 'a1E58000003DRGkEAO', 'a1E58000003DRGdEAO', 'a1E58000003DRGyEAO', 'a1E3E000003GRtuUAG', 'a1E58000003DRInEAO', 'a1E3E000003GRvYUAW', 'a1E3E000003GRtbUAG', 'a1E58000003DRHYEA4', 'a1E3E000003GRwyUAG', 'a1E3E000003GRv9UAG', 'a1E58000003DRIJEA4', 'a1E58000003DRGwEAO', 'a1E58000003DRIpEAO', 'a1E58000003DRIbEAO', 'a1E3E000003GRxMUAW', 'a1E3E000003GRuhUAG', 'a1E58000003DRGzEAO', 'a1E58000003DRGxEAO', 'a1E58000003DRGmEAO', 'a1E3E000003GRuKUAW', 'a1E58000003DRGcEAO', 'a1E3E000003GRrEUAW', 'a1E3E000003GRx9UAG', 'a1E3E000003GRrnUAG', 'a1E58000003DRJ4EAO', 'a1E58000003DRIdEAO', 'a1E58000003DRIREA4', 'a1E58000003DRHeEAO', 'a1E3E000003GRx8UAG', 'a1E3E000003GRx7UAG', 'a1E58000003DRGrEAO', 'a1E3E000003GRukUAG', 'a1E58000003DRGpEAO', 'a1E58000003DRIcEAO', 'a1E3E000003GRvCUAW', 'a1E58000003DRJGEA4', 'a1E3E000003GRv5UAG', 'a1E58000003DRHOEA4', 'a1E3E000003GRr8UAG', 'a1E3E000003GRv6UAG', 'a1E3E000003GRvuUAG', 'a1E3E000003GRuZUAW', 'a1E3E000003GRrrUAG', 'a1E3E000003GRwSUAW', 'a1E3E000003GRuvUAG', 'a1E3E000003GRtpUAG', 'a1E3E000003GRxVUAW', 'a1E58000003DRHVEA4', 'a1E58000003DRGfEAO', 'a1E58000003DRGaEAO', 'a1E3E000003GRwhUAG', 'a1E3E000003GRx0UAG', 'a1E58000003DRGVEA4', 'a1E58000003DRHdEAO', 'a1E3E000003GRx6UAG', 'a1E3E000003GRwfUAG', 'a1E3E000003GRwzUAG', 'a1E58000003DRIYEA4', 'a1E58000003DRILEA4', 'a1E58000003DRH4EAO', 'a1E58000003DRIPEA4', 'a1E58000003DRIjEAO', 'a1E3E000003GRrDUAW', 'a1E3E000003GRubUAG', 'a1E58000003DRIGEA4', 'a1E3E000003GRvtUAG', 'a1E3E000003GRtXUAW', 'a1E58000003DRJKEA4', 'a1E58000003DRJ3EAO', 'a1E3E000003GRvLUAW', 'a1E58000003DRH7EAO', 'a1E58000003DRIOEA4', 'a1E3E000003GRtrUAG', 'a1E3E000003GRtAUAW', 'a1E58000003DRHFEA4', 'a1E58000003DRH0EAO', 'a1E3E000003GRv7UAG', 'a1E3E000003GRvEUAW', 'a1E58000003DRGuEAO', 'a1E58000003DRIAEA4', 'a1E58000003DRGjEAO', 'a1E58000003DRGeEAO', 'a1E58000003DRHbEAO', 'a1E58000003DRGhEAO', 'a1E3E000003GRvFUAW', 'a1E3E000003GRvIUAW', 'a1E3E000003GRxCUAW', 'a1E3E000003GRvsUAG', 'a1E3E000003GRvNUAW', 'a1E58000003DRIkEAO', 'a1E58000003DRIVEA4', 'a1E3E000003GRvZUAW', 'a1E58000003DRHTEA4', 'a1E58000003DRIIEA4', 'a1E3E000003GRvfUAG', 'a1E58000003DRGZEA4', 'a1E58000003DRIKEA4', 'a1E58000003DRJAEA4', 'a1E3E000003GRvlUAG', 'a1E58000003DRGWEA4', 'a1E3E000003GRwWUAW', 'a1E3E000003GRvkUAG', 'a1E58000003DRI9EAO', 'a1E58000003DRINEA4', 'a1E58000003DRIQEA4', 'a1E58000003DRJ5EAO', 'a1E58000003DRGiEAO', 'a1E3E000003GRwwUAG', 'a1E58000003DRJEEA4', 'a1E58000003DRIfEAO', 'a1E58000003DRHnEAO', 'a1E58000003DRGnEAO', 'a1E58000003DRHUEA4', 'a1E3E000003GRxLUAW', 'a1E58000003DRJ7EAO', 'a1E58000003DRIZEA4', 'a1E58000003DRHNEA4', 'a1E3E000003GRvAUAW', 'a1E58000003DRHZEA4', 'a1E3E000003GRwgUAG', 'a1E3E000003GRvyUAG', 'a1E3E000003GRvDUAW', 'a1E58000003DRI0EAO', 'a1E3E000003GRulUAG', 'a1E3E000003GRv3UAG', 'a1E3E000003GRxBUAW', 'a1E58000003DRH2EAO', 'a1E58000003DRHIEA4', 'a1E58000003DRHcEAO', 'a1E58000003DRH3EAO', 'a1E58000003DRIxEAO', 'a1E3E000003GRuLUAW', 'a1E58000003DRGsEAO', 'a1E58000003DRIiEAO', 'a1E58000003DRIEEA4', 'a1E3E000003GRx1UAG', 'a1E3E000003GRraUAG', 'a1E58000003DRHrEAO', 'a1E58000003DRJDEA4']
    # print entity_filters
    handle("vlocityentityfilter", entity_filters, 0)


if __name__ == '__main__':
    main()