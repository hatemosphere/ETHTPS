import re
import csv
from datetime import datetime

# Define regular expressions to match SQL INSERT statements and datetime values
insert_regex = re.compile(r'^\s*INSERT\s+INTO\s+(\w+)\s*\((.*)\)\s*VALUES\s*(\(.+\)(?:\s*,\s*\(.+\))*)\s*;?\s*$', re.MULTILINE)
datetime_regex = re.compile(r"CONVERT\(datetime,'(.+?)',121\)")

# Define a function to extract values from SQL INSERT statements and write them to a CSV file
def process_insert(sql_insert):
    print(f"Processing SQL INSERT statement: {sql_insert}")
    # Use regular expressions to extract table name and values from SQL INSERT statement
    table_name, columns_str, values_str = sql_insert

    # Split the column names and values into lists
    column_list = [c.strip() for c in columns_str.split(',')]
    value_lists = [[parse_datetime(v.strip().strip("'")) if datetime_regex.match(v.strip()) else v.strip().strip("'") for v in value_str.split(',')] for value_str in re.findall('\(([^)]+?)\)', values_str)]

    # Open the CSV file for the table and write the values to it
    if value_lists:
        with open(f'{table_name}.csv', 'a', newline='') as csv_file:
            writer = csv.writer(csv_file)
            writer.writerows(value_lists)

def parse_datetime(datetime_str):
    # Parse the datetime string to a Python datetime object
    return datetime.strptime(datetime_str, '%Y-%m-%d %H:%M:%S.%f')

# Read the entire input file into a string
with open('input.sql', 'r') as sql_file:
    input_string = sql_file.read()

# Remove any empty lines from the input string
input_string = '\n'.join([line for line in input_string.split('\n') if line.strip()])

# Find all INSERT statements in the input string using regular expressions
insert_statements = insert_regex.findall(input_string)
print(insert_statements)

# Process each INSERT statement and write values to a CSV file
for insert_statement in insert_statements:
    process_insert(insert_statement)

# Generate bulk INSERT statements for each table and write them to a new SQL file
bulk_inserts = []
for table_name in set([statement[0] for statement in insert_statements]):
    bulk_inserts.append('BULK\nINSERT {table}\nFROM \'{csv}\'\nWITH\n(FIELDTERMINATOR = \',\',\nROWTERMINATOR = \'\\n\')\n'.format(
        table=table_name,
        csv=table_name + '.csv'
    ))

with open('output.sql', 'w') as output_file:
    output_file.write('\n'.join(bulk_inserts))
