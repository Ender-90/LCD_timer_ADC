'Microcontroller declaration

$regfile = "m8adef.dat"
$crystal = 8000000
$hwstack = 40
$swstack = 40
$framesize = 40

' LCD pin configuration

Config Lcdpin = Pin , Db4 = Portd.4 , Db5 = Portd.3 , Db6 = Portd.2 , Db7 = Portd.1 , E = Portc.1 , Rs = Portc.0
Config Lcd = 16 * 2

' ADC and TIMER0 configuration

Config Adc = Single , Prescaler = Auto , Reference = Internal
Config Timer0 = Timer , Prescale = 64
On Timer0 Interrupt_2ms

' Declaration of variables

Dim Timecounter As Integer
Dim S As Byte
Dim M As Byte
Dim H As Byte
Dim Temperature As Word
Dim Skull As Bit

' Declaration of custom characters, which will be used later

Deflcdchar 0,32,32,1,3,15,2,6,10
Deflcdchar 1,32,31,32,31,31,32,27,27
Deflcdchar 2, 32, 32, 24, 26, 30, 8, 12, 10
Deflcdchar 3, 7, 1, 7, 8, 5, 2, 32, 32
Deflcdchar 4, 4, 17, 14, 17, 14, 32, 32, 32
Deflcdchar 5, 28, 16, 28, 2, 20, 8, 32, 32
Deflcdchar 6 , 6 , 9 , 9 , 6 , 0 , 0 , 0 , 0

' Switch On ADC, TIMER0 and interrupts

Start Adc
Enable Interrupts
Enable Timer0

' set TIMER0 value. It's important for better timing precision 

Timer0 = 6

' set initial variable values

Timecounter  = 0
S = 50
M = 59
H = 9
Skull = 0

' switch off underline in LCD Display

Cursor Off Noblink

' Main application loop

Do


' This block of code is executed at every full hour
If Skull = 1 Then

Cls
Locate 1, 3
LCD Chr(0); Chr(1); Chr(2)
Locate 1, 12
LCD Chr(0); Chr(1); Chr(2)

Locate 2,3
LCD Chr(3); Chr(4); Chr(5)
Locate 2, 12
LCD Chr(3); Chr(4); Chr(5)

Wait 2

Cls

Wait 2

Cls
Locate 1, 3
LCD Chr(0); Chr(1); Chr(2)
Locate 1, 12
LCD Chr(0); Chr(1); Chr(2)

Locate 2,3
LCD Chr(3); Chr(4); Chr(5)
Locate 2, 12
LCD Chr(3); Chr(4); Chr(5)

Wait 2

Cls

Wait 2


Lcd "Danger!  Danger!"

Wait 2

Cls
Locate 1,5
LCD "Next hour"
Wait 2

Locate 2,3
Lcd "has coming!"

Skull = 0

Wait 2


' This block of code is responsible for displaying time and temperature

Else

CLS

If H < 10 Then
Locate 1 , 10
Lcd H
Else
Locate 1 , 9
Lcd H
End If


Lcd ":"

If M < 10 Then
Lcd 0
Lcd M
Else
Lcd M
End If

LCD ":"

If S < 10 Then
Lcd 0
Lcd S
Else
Lcd S
End If

Temperature = Getadc(5) / 4
Temperature = temperature + 2

Locate 2, 13
Lcd Temperature
Lcd Chr(6)
Lcd "C"

Waitms 200

End If

Loop

End


' Interrup, which follows every 2 miliseconds

Interrupt_2ms:

Timer0 = Timer0 + 6

Incr Timecounter 
If Timecounter  = 500 Then
Incr S
Timecounter  = 0
End If

If S > 59 Then
Incr M
S = 0
End If

If M > 59 Then
Incr H
M = 0
End If

If M = 0 AND S =0 AND Timecounter  = 0 THEN
Skull = 1
End If

If H > 23 Then
H = 0

End If

Return