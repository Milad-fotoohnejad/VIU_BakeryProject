import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:excel/excel.dart';
import 'package:file_picker_cross/file_picker_cross.dart';

class ExcelReader extends StatefulWidget {
  @override
  _ExcelReaderState createState() => _ExcelReaderState();
}

class _ExcelReaderState extends State<ExcelReader> {
  late List<PlutoColumn> _excelColumns;
  late List<PlutoRow> _excelData;
  late Excel _excel;
  late String _filePath;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExcel();
  }

  Future<void> _loadExcel() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Load the file from the assets
      ByteData data =
          await rootBundle.load('excelFiles/BaguetteWithLevain.xlsx');
      if (data != null && data.lengthInBytes > 0) {
        _excel = Excel.decodeBytes(data.buffer.asUint8List());
        _loadExcelColumns();
        _loadExcelData();
      } else {
        Navigator.pop(context);
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } on Exception {
      print("File loading error or another error occurred");
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _loadExcelColumns() {
    int index = 0;
    _excelColumns = [
      for (final cell in _excel.tables.values.first.rows.first.toList())
        PlutoColumn(
          title: cell?.value?.toString() ?? '',
          field: (cell?.value?.toString() ?? '') + '_${index++}',
          type: _determineColumnType(cell?.value),
        ),
    ];
  }

  PlutoColumnType _determineColumnType(dynamic value) {
    if (value == null) {
      return PlutoColumnType.text(defaultValue: '');
    } else if (value is int) {
      return PlutoColumnType.number(defaultValue: 0);
    } else if (value is double) {
      return PlutoColumnType.number(defaultValue: 0.0);
    } else if (value is DateTime) {
      return PlutoColumnType.date(defaultValue: DateTime.now());
    } else {
      return PlutoColumnType.text(defaultValue: '');
    }
  }

  void _loadExcelData() {
    final sheet = _excel.tables.values.first;
    final data = sheet.rows.map((row) => row.toList()).toList();

    _excelData = [
      for (final rowData in data)
        PlutoRow(cells: {
          for (int i = 0; i < rowData.length; i++)
            _excelColumns[i].field: PlutoCell(value: rowData[i]),
        }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excel Reader'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(8.0),
              child: PlutoGrid(
                columns: _excelColumns,
                rows: _excelData,
                onChanged: (PlutoGridOnChangedEvent event) {},
              ),
            ),
    );
  }
}
