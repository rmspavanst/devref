
#! /usr/bin/python

# Insert Multiple Images into Excel Cells with Python
# PULL IN FILENAMES AND TITLES INSTEAD OF ADDING MANUALLY

import xlsxwriter

#import glob
#import os
#from natsort import natsorted

# create a new Excel file and add a worksheet
workbook = xlsxwriter.Workbook('/root/screenshot/excel/images.xlsx')
worksheet = workbook.add_worksheet()

# resize cells
worksheet.set_column('B5:B10', 7)
worksheet.set_default_row(40)



# images list
images = ['/root/screenshot/excel/ansible-win1/about.png',
          '/root/screenshot/excel/ansible-win1/wsup.png', 
          '/root/screenshot/excel/ansible-win1/wsup_option.png']
          

# insert images
image_row = 0 
image_col = 1
for image in images:
    worksheet.insert_image(image_row, 
                           image_col, 
                           image, 
                           {'x_scale': 0.1, 'y_scale': 0.1, 
                            'x_offset': 5, 'y_offset': 5,
                            'positioning': 1}) 
    # positioning = 1 allows move and size with cells (may not always perform as expected)
    image_row += 1
    
# titles list
titles = [ 'about', 'wsup', 'wsup_option' ]

# insert titles
title_row = 0
title_col = 0
for title in titles:
    worksheet.write(title_row,
                    title_col,
                    title)
    title_row += 1

workbook.close()
