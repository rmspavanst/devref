#https://www.youtube.com/watch?v=3mWqQlYlFlY


# Insert Multiple Images into Excel Cells with Python
# PULL IN FILENAMES AND TITLES INSTEAD OF ADDING MANUALLY

import xlsxwriter
#import glob
#import os
#from natsort import natsorted

# create a new Excel file and add a worksheet
#workbook = xlsxwriter.Workbook('excel_insert_images.xlsx')
workbook = xlsxwriter.Workbook('C:\Users\systemizer\Videos\Debut\excel_insert_images.xlsx')
worksheet = workbook.add_worksheet()

# resize cells
worksheet.set_column('B1:B5', 7)
#worksheet.set_column(first_col=0, last_col=0, width=10)
#worksheet.set_column(first_col=1, last_col=1, width=7)
worksheet.set_default_row(45)

# images list
images = ['C:\Users\systemizer\Videos\Debut\about.png',
          'C:\Users\systemizer\Videos\Debut\wsup.png', 
          'C:\Users\systemizer\Videos\Debut\wsup_option.png']
          
#for filename in natsorted(glob.glob('Shapes/*.png')):
#    images.append(filename)

# insert images
image_row = 0
image_col = 1
for image in images:
    worksheet.insert_image(image_row, 
                           image_col, 
                           image, 
                           {'x_scale': 0.5, 'y_scale': 0.5, 
                            'x_offset': 5, 'y_offset': 5,
                            'positioning': 1}) 
    # positioning = 1 allows move and size with cells (may not always perform as expected)
    image_row += 1
    
# titles list
titles = [ 'about', 'wsup', 'wsup_option' ]
#for title in natsorted(glob.glob('Shapes/*.png')):
#    titles.append(os.path.basename(title))

# insert titles
title_row = 0
title_col = 0
for title in titles:
    worksheet.write(title_row,
                    title_col,
                    title)
    title_row += 1

workbook.close()