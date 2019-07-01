import speech_recognition as sr
import webbrowser as wb
from robot.libraries.BuiltIn import BuiltIn
import pandas
import xlrd
import os as os
from pathlib import Path
import sys
#do pip install xlrd for reading excel
#do pip install pandas also for reading
#do pip install pathlib for getting path related things
def Open_File_from_Resources(file_name):

    file_path = Path(__file__).parent.parent.joinpath('resources\\' + file_name)
    return file_path

    #this below line fetches the root directory of the project __file__ to get the path of current file
    #proj_root_id = os.path.dirname(sys.modules['__main__'].__file__)
    #return 'file:///' + proj_root_id + '\/claudia-pipeline\/robot_tests\/resources\/'+ file_name
    #return proj_root_id

def read_excel(p1):

    #this logic works
    #excel_path = Open_File_from_Resources(p1)
    #print excel_path
    #df1 = pandas.read_excel(excel_path)
    #result_list = list()
    #result_list.append(df1)
    #return result_list

    #excel_path = Open_File_from_Resources(p1)
    workbook = xlrd.open_workbook('C:\Users\mmw9007\Desktop\excel_account_data.xlsx')
    sheet = workbook.sheet_by_name("Sheet1")
    rowCount = sheet.nrows
    colCount = sheet.ncols
    print rowCount
    print colCount
    result_data = []
    d1 = {}
    d2 = {}
    for curr_row in range(0, rowCount, 1):
        row_data = []

        for curr_col in range(0, colCount, 1):
            data = sheet.cell_value(curr_row, curr_col)  # Read the data in the current cell
            #print data
            row_data.append(data)

        result_data.append(row_data)

    print result_data
    print d1
    return result_data

def main():
    print "helloo"
    proj_root_id = os.path.dirname(os.path.abspath("somethong"))
    print proj_root_id
    final_path = proj_root_id +'\\'+ 'excel_account_data.xlsx'
    print final_path
    df1 = pandas.read_excel(final_path)



if __name__ == "__main__":
   read_excel('excel_account_data.xlsx')



