#communication computer - FPGA
import serial
import time
import csv

def printToFile(data, index):
  resultsFile.write(data)
  if index != (numSamples -1):
    resultsFile.write(',')
  else:
    resultsFile.write('\n')

ser = serial.Serial('/dev/ttyUSB13', baudrate=115200, timeout=1)
time.sleep(3) #wait 3 seconds for the FPGA to initialize
numSamples = 9
numRows = 10
resultsFile = open('results.csv', 'w')

#transmit data
with open('data_in.csv') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    i_count = 0
    for row in csv_reader:
        for sample in row:
            if float(sample) >= 0:
                ser.write(chr(int(sample)))
            if float(sample) < 0: #negative
                ser.write(chr(256+int(sample)))
            processedData = ser.read()
            print(ord(processedData))
            if float(ord(processedData)) < 128:
                dato_out = str(ord(processedData))
                printToFile(dato_out, i_count)
            if float(ord(processedData)) >=128: #negative
                dato_out=str((int(ord(processedData))-256))
                printToFile(dato_out, i_count)
            i_count += 1
            if i_count == 10:
                i_count = 1
resultsFile.close()


