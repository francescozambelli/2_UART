import serial
ser = serial.Serial('/dev/ttyUSB13', baudrate=115200)
def chr_conv(x):
    if x>=0:
	return x
    elif x<0:
	return 256+x

def dec_conv(x):
    if x<=127:
	return x*(2**5)
    elif x>127:
        return (x-256)*(2**5)

imp_list=[21,22,23,24,25]
iniz_list=[0,0,0,0,0,0,0,0]

for i in range(len(imp_list)):
  ser.write(chr(chr_conv(imp_list[i])))
  d = ser.read()
  print(dec_conv(ord(d)))

for i in range(len(iniz_list)):
  ser.write(chr(chr_conv(iniz_list[i])))
  d = ser.read()


