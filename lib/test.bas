flutter build apk --build-name=2.6 --build-number=17


Sub DrawSquareWithDimensions()
Kupalnik
Rucav
DrawCheckSquare
End Sub
 Public Sub AddLine(startX As Double, startY As Double, endX As Double, endY As Double)
 
   Dim startPoint(0 To 2) As Double
   Dim endPoint(0 To 2) As Double
        startPoint(0) = startX
        startPoint(1) = startY
        startPoint(2) = 0

        endPoint(0) = endX
        endPoint(1) = endY
        endPoint(2) = 0
ThisDrawing.ModelSpace.AddLine startPoint, endPoint
    End Sub
    Public Sub AddLineKri5(startX As Double, startY As Double, endX As Double, endY As Double)
    Dim splineObj As AcadSpline
    Dim startTan(0 To 2) As Double
    Dim endTan(0 To 2) As Double
    Dim fitPoints(0 To 14) As Double
    startTan(0) = 0: startTan(1) = 0: startTan(2) = 0
    endTan(0) = 0: endTan(1) = 0: endTan(2) = 0
    fitPoints(0) = startX
    fitPoints(1) = startY
    fitPoints(2) = 0
    fitPoints(3) = startX + (endX - startX) / 4
    fitPoints(4) = startY + (endY - startY) / 4
    fitPoints(5) = 0
    fitPoints(6) = startX + (endX - startX) / 2
    fitPoints(7) = startY + (endY - startY) / 2
    fitPoints(8) = 0
    fitPoints(9) = startX + 3 * (endX - startX) / 4
    fitPoints(10) = startY + 3 * (endY - startY) / 4
    fitPoints(11) = 0
    fitPoints(12) = endX
    fitPoints(13) = endY
    fitPoints(14) = 0
    Set splineObj = ThisDrawing.ModelSpace.AddSpline(fitPoints, startTan, endTan)
End Sub
Public Sub AddLineKri4(startX As Double, startY As Double, endX As Double, endY As Double)
    Dim splineObj As AcadSpline
    Dim startTan(0 To 2) As Double
    Dim endTan(0 To 2) As Double
    Dim fitPoints(0 To 5) As Double
    startTan(0) = 0: startTan(1) = 0: startTan(2) = 0
    endTan(0) = 0: endTan(1) = 0: endTan(2) = 0
    fitPoints(0) = startX
    fitPoints(1) = startY
    fitPoints(2) = 0
    fitPoints(3) = startX + (endX - startX) / 3
    fitPoints(4) = startY + (endY - startY) / 3
    fitPoints(5) = 0
    fitPoints(6) = startX + 2 * (endX - startX) / 3
    fitPoints(7) = startY + 2 * (endY - startY) / 3
    fitPoints(8) = 0
    fitPoints(9) = endX
    fitPoints(10) = endY
    fitPoints(11) = 0
    Set splineObj = ThisDrawing.ModelSpace.AddSpline(fitPoints, startTan, endTan)
End Sub
Public Sub AddLineKri3(startX As Double, startY As Double, endX As Double, endY As Double)
     Dim splineObj As AcadSpline
    Dim startTan(0 To 2) As Double
    Dim endTan(0 To 2) As Double
    Dim midX As Double
    Dim midY As Double
    Dim fitPoints(0 To 8) As Double
    startTan(0) = 0: startTan(1) = 0: startTan(2) = 0
    endTan(0) = 0: endTan(1) = 0: endTan(2) = 0
    midX = (startX + endX) / 2
    midY = (startY + endY) / 2
    fitPoints(0) = startX
    fitPoints(1) = startY
    fitPoints(2) = 0
    fitPoints(3) = midX
    fitPoints(4) = midY
    fitPoints(5) = 0
    fitPoints(6) = endX
    fitPoints(7) = endY
    fitPoints(8) = 0
    Set splineObj = ThisDrawing.ModelSpace.AddSpline(fitPoints, startTan, endTan)
End Sub
Public Sub AddLineKri2(startX As Double, startY As Double, endX As Double, endY As Double)
    Dim splineObj As AcadSpline
    Dim startTan(0 To 2) As Double
    Dim endTan(0 To 2) As Double
    Dim fitPoints(0 To 5) As Double
    startTan(0) = 0: startTan(1) = 0: startTan(2) = 0
    endTan(0) = 0: endTan(1) = 0: endTan(2) = 0
    fitPoints(0) = startX: fitPoints(1) = startY: fitPoints(2) = 0
    fitPoints(3) = endX: fitPoints(4) = endY: fitPoints(5) = 0
    Set splineObj = ThisDrawing.ModelSpace.AddSpline(fitPoints, startTan, endTan)
    End Sub
    Public Sub AddLineKri3zad(startX As Double, startY As Double, endX As Double, endY As Double)
    Dim splineObj As AcadSpline
    Dim startTan(0 To 2) As Double
    Dim endTan(0 To 2) As Double
    Dim fitPoints(0 To 8) As Double
    Dim midX As Double
    Dim midY As Double
    startTan(0) = 0: startTan(1) = 0: startTan(2) = 0
    endTan(0) = 0: endTan(1) = -0: endTan(2) = 0
    midX = (startX + endX) / 2
    midY = (startY + endY) / 2
    fitPoints(0) = startX
    fitPoints(1) = startY
    fitPoints(2) = 0
    fitPoints(3) = midX
    fitPoints(4) = midY
    fitPoints(5) = 0
    fitPoints(6) = endX
    fitPoints(7) = endY
    fitPoints(8) = 0
    Set splineObj = ThisDrawing.ModelSpace.AddSpline(fitPoints, startTan, endTan)
    End Sub
 Public Sub Rucav()
 Dim first, firstY As Double
    Dim firstX As Double: firstX = 0
    
    Dim second, secondY As Double
    Dim secondX As Double: secondX = 0
    
    Dim third, thirdY As Double: third = 20
    
    Dim thirdX As Double: thirdX = 0
    
    Dim fourth, fourthY As Double: fourth = 25
    Dim fourthX As Double: fourthX = 0
    
    Dim fifth, fifthY As Double
    Dim fifthX As Double: fifthX = 0
    
    Dim sixth, sixthY As Double
    Dim sixthX As Double: sixthX = 0
    
    Dim seventh, seventhY As Double
    Dim seventhX As Double: seventhX = 0
    
    Dim eighth, eighthY As Double
    Dim eighthX As Double: eighthX = 0
    
    Dim location1(0 To 2) As Double
    Dim dimLine1 As AcadDimAligned
    
    Dim startPoint(0 To 2) As Double
    Dim endPoint(0 To 2) As Double
    
    
    Dim standart As Double: standart = 9
    Dim distan As Double: distan = 50
   
    first = 0
    firstX = 0 + distan
    firstY = standart
    
    second = ${calculatedMeasurements[11].toStringAsFixed(2)} -  standart 
    secondX = 0 + distan
    secondY = secondY - second
    
    AddLine firstX, firstY, secondX, secondY

    AddLine firstX, firstY, secondX, secondY
    '-----------------------------------------------------------------------------
    third = 0
    thirdX = 0 + distan
    thirdY = 0
    
    fifth = ${calculatedMeasurements[22].toStringAsFixed(2)}
    sixth = ${calculatedMeasurements[22].toStringAsFixed(2)}
    
    
    fifthX = thirdX - fifth / 2
    sixthX = thirdX + sixth / 2
    
    fifthY = thirdY
    sixthY = thirdY
   
    
    AddLine fifthX, fifthY, sixthX, sixthY
    '-----------------------------------------------------------------------------
        
    seventh = ${calculatedMeasurements[4].toStringAsFixed(2)}
    eighth = ${calculatedMeasurements[4].toStringAsFixed(2)}
    
    
    seventhX = secondX - seventh / 2
    eighthX = secondX + eighth / 2
    
    seventhY = secondY
    eighthY = secondY
  
    
    AddLine seventhX, seventhY, eighthX, eighthY
    '-----------------------------------------------------------------------------
    
    
    AddLineKri5 firstX, firstY, fifthX, fifthY
    AddLineKri5 firstX, firstY, sixthX, sixthY
    AddLineKri5 fifthX, fifthY, seventhX, seventhY
    AddLineKri5 sixthX, sixthY, eighthX, eighthY
    
 End Sub
Public Sub Kupalnik()
  Dim obj As AcadObject
    For Each obj In ThisDrawing.ModelSpace
        obj.Delete
    Next obj
    
    Dim first, firstY As Double
    Dim firstX As Double: firstX = 0
    
    Dim second, secondY As Double
    Dim secondX As Double: secondX = 0
    
    Dim third, thirdY As Double: third = 20
    Dim thirdX As Double: thirdX = 0
    
    Dim fourth, fourthY As Double: fourth = 25
    Dim fourthX As Double: fourthX = 0
    
    Dim fifth, fifthY As Double: fifth = 15
    Dim fifthX As Double: fifthX = 0
    
    Dim sixth, sixthY As Double
    Dim sixthX As Double: sixthX = 0
    
    Dim seventh, seventhY As Double: seventh = 22
    Dim seventhX As Double: seventhX = 0
    
    Dim eighth, eighthY As Double: eighth = 17
    Dim eighthX As Double: eighthX = 0
    
    Dim ninth, ninthY As Double: ninth = 20
    Dim ninthX As Double: ninthX = 0
    
    Dim tenth, tenthY As Double: tenth = 23
    Dim tenthX As Double: tenthX = 0
    
    Dim eleventh, eleventhY As Double: eleventh = 10
    Dim eleventhX As Double: eleventhX = 0
    
    Dim twelfth, twelfthY As Double: twelfth = 13
    Dim twelfthX As Double: twelfthX = 0
    
    Dim thirteen, thirteenY As Double: thirteen = 5
    Dim thirteenX As Double: thirteenX = 0
    
    Dim fourteen, fourteenY As Double
    Dim fourteenX As Double: fourteenX = 0
    
    Dim fifteen, fifteenY As Double: fifteen = 10
    Dim fifteenX As Double: fifteenX = 0
    
    Dim location1(0 To 2) As Double
    Dim dimLine1 As AcadDimAligned
    
    Dim startPoint(0 To 2) As Double
    Dim endPoint(0 To 2) As Double
      
    first = 0
    firstX = 0
    firstY = 0
    
    second = ${calculatedMeasurements[12].toStringAsFixed(2)}
    secondX = 0
    secondY = secondY - second
    AddLine firstX, firstY, secondX, secondY
    
    location1(0) = firstX - 15#: location1(1) = 0#: location1(2) = 0#
AddLine firstX, firstY, secondX, secondY
    '-----------------------------------------------------------------------------
    
    location1(0) = 0#: location1(1) = 0#: location1(2) = 0#
    
    twelfth = 5
    sixth = ${calculatedMeasurements[0].toStringAsFixed(2)}
    seventh = ${calculatedMeasurements[6].toStringAsFixed(2)}
    
    
    twelfthX = 0
    twelfthY = twelfth * -1
    
    sixthX = sixth
    sixthY = 0
    
    AddLineKri2 twelfthX, twelfthY, sixthX, sixthY
    AddLineKri2 twelfthX, twelfthY - 3, sixthX, sixthY
    
    seventhX = seventh
    seventhY = -3 '????????
    
    AddLine seventhX, seventhY, sixthX, sixthY
    
    
    
   '-----------------------------------------------------------------------------
   fifth = ${calculatedMeasurements[9].toStringAsFixed(2)}
   ninth = ${calculatedMeasurements[1].toStringAsFixed(2)}
   
   fifthX = 0
   fifthY = fifth * -1
   
   ninthX = ninth
   ninthY = fifthY
   location1(0) = 0: location1(1) = 0#: location1(2) = 0#
    
   AddLine fifthX, fifthY, ninthX, ninthY
   
   '----------------------------------------------------------------------------
    
    fifteen = fifth / 2
    eleventh = ${calculatedMeasurements[7].toStringAsFixed(2)}
    
    
    fifteenX = 0
    fifteenY = fifteen * -1
    
    eleventhX = eleventh
    eleventhY = fifteenY
    
    location1(0) = 0: location1(1) = 0#: location1(2) = 0#
    
    AddLine fifteenX, fifteenY, eleventhX, eleventhY
    '-----------------------------------------------------------------------------
    
    third = ${calculatedMeasurements[14].toStringAsFixed(2)}
    eighth = ${calculatedMeasurements[2].toStringAsFixed(2)}
    
    
    thirdX = 0
    thirdY = third * -1
    
    eighthX = eighth
    eighthY = thirdY
    
    
    location1(0) = 0: location1(1) = 0#: location1(2) = 0#
     AddLine thirdX, thirdY, eighthX, eighthY
    '-----------------------------------------------------------------------------
    
    fourth = ${calculatedMeasurements[10].toStringAsFixed(2)}
    tenth = ${calculatedMeasurements[3].toStringAsFixed(2)}
    
    fourthX = 0
    fourthY = thirdY - fourth
    
    tenthX = tenth
    tenthY = fourthY
    
    location1(0) = 0: location1(1) = 0#: location1(2) = 0#
    AddLine tenthX, tenthY, fourthX, fourthY
    '-----------------------------------------------------------------------------
    
    thirteen = 4 '????????? ??
    
    thirteenY = secondY
    thirteenX = thirteen
    
    location1(0) = 0: location1(1) = 0#: location1(2) = 0#
    AddLine thirteenX, thirteenY, secondX, secondY
    '-----------------------------------------------------------------------------
    
    
    AddLineKri2 seventhX, seventhY, eleventhX, eleventhY
    AddLineKri2 eleventhX, eleventhY, ninthX, ninthY
    AddLineKri2 ninthX, ninthY, eighthX, eighthY
    AddLineKri2 eighthX, eighthY, tenthX, tenthY
    AddLineKri5 tenthX, tenthY, thirteenX, thirteenY
    AddLineKri3zad tenthX, tenthY, thirteenX, thirteenY
    
End Sub

Sub DrawCheckSquare()
    Dim checkSquareSize As Double
    checkSquareSize = 3

    Dim topLeftX As Double: topLeftX = 5
    Dim topLeftY As Double: topLeftY = -5
    Dim bottomRightX As Double: bottomRightX = topLeftX + checkSquareSize
    Dim bottomRightY As Double: bottomRightY = topLeftY - checkSquareSize

    AddLine topLeftX, topLeftY, topLeftX, bottomRightY
    AddLine topLeftX, bottomRightY, bottomRightX, bottomRightY
    AddLine bottomRightX, bottomRightY, bottomRightX, topLeftY
    AddLine bottomRightX, topLeftY, topLeftX, topLeftY
End Sub
