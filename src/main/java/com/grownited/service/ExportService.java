package com.grownited.service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.List;

// Apache POI imports (Excel)
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

// iText imports (PDF) - Use fully qualified names
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

import org.springframework.stereotype.Service;

import com.grownited.entity.ExpenseEntity;

@Service
public class ExportService {

  // ========== EXCEL EXPORT ==========
  public byte[] exportExpensesToExcel(List<ExpenseEntity> expenses, String userName) throws IOException {

    Workbook workbook = new XSSFWorkbook();
    Sheet sheet = workbook.createSheet("Expenses");

    // Create header style
    CellStyle headerStyle = workbook.createCellStyle();
    org.apache.poi.ss.usermodel.Font headerFont = workbook.createFont();
    headerFont.setBold(true);
    headerFont.setFontHeightInPoints((short) 12);
    headerFont.setColor(IndexedColors.WHITE.getIndex());
    headerStyle.setFont(headerFont);
    headerStyle.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
    headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
    headerStyle.setBorderBottom(BorderStyle.THIN);
    headerStyle.setBorderTop(BorderStyle.THIN);
    headerStyle.setBorderRight(BorderStyle.THIN);
    headerStyle.setBorderLeft(BorderStyle.THIN);

    // Create currency style
    CellStyle currencyStyle = workbook.createCellStyle();
    DataFormat formatData = workbook.createDataFormat();
    currencyStyle.setDataFormat(formatData.getFormat("$#,##0.00"));

    // Title Row
    Row titleRow = sheet.createRow(0);
    Cell titleCell = titleRow.createCell(0);
    titleCell.setCellValue("SpendWise - Expense Report");
    CellStyle titleStyle = workbook.createCellStyle();
    org.apache.poi.ss.usermodel.Font titleFont = workbook.createFont();
    titleFont.setBold(true);
    titleFont.setFontHeightInPoints((short) 16);
    titleStyle.setFont(titleFont);
    titleCell.setCellStyle(titleStyle);

    Row userRow = sheet.createRow(1);
    userRow.createCell(0).setCellValue("Generated for: " + userName);

    // Header Row
    Row headerRow = sheet.createRow(3);
    String[] headers = {"ID", "Date", "Title", "Category", "Amount", "Description", "Status"};

    for (int i = 0; i < headers.length; i++) {
      Cell cell = headerRow.createCell(i);
      cell.setCellValue(headers[i]);
      cell.setCellStyle(headerStyle);
    }

    // Data Rows
    int rowNum = 4;
    double totalAmount = 0;

    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    for (ExpenseEntity expense : expenses) {
      Row row = sheet.createRow(rowNum++);

      row.createCell(0).setCellValue(expense.getExpenseId());

      Cell dateCell = row.createCell(1);
      if (expense.getTranscationDate() != null) {
        dateCell.setCellValue(expense.getTranscationDate().format(dateFormatter));
      } else {
        dateCell.setCellValue("N/A");
      }

      row.createCell(2).setCellValue(expense.getTitle() != null ? expense.getTitle() : "");
      row.createCell(3).setCellValue("Category " + (expense.getCategoryId() != null ? expense.getCategoryId() : "N/A"));

      Cell amountCell = row.createCell(4);
      amountCell.setCellValue(expense.getAmount());
      amountCell.setCellStyle(currencyStyle);

      row.createCell(5).setCellValue(expense.getDescription() != null ? expense.getDescription() : "");
      row.createCell(6).setCellValue(expense.isStatus() ? "Active" : "Inactive");

      totalAmount += expense.getAmount();
    }

    // Total Row
    Row totalRow = sheet.createRow(rowNum + 1);
    Cell totalLabelCell = totalRow.createCell(3);
    totalLabelCell.setCellValue("TOTAL:");

    org.apache.poi.ss.usermodel.Font boldFont = workbook.createFont();
    boldFont.setBold(true);
    CellStyle boldStyle = workbook.createCellStyle();
    boldStyle.setFont(boldFont);
    totalLabelCell.setCellStyle(boldStyle);

    Cell totalAmountCell = totalRow.createCell(4);
    totalAmountCell.setCellValue(totalAmount);

    CellStyle totalCurrencyStyle = workbook.createCellStyle();
    totalCurrencyStyle.cloneStyleFrom(currencyStyle);
    org.apache.poi.ss.usermodel.Font totalExcelFont = workbook.createFont();
    totalExcelFont.setBold(true);
    totalCurrencyStyle.setFont(totalExcelFont);
    totalAmountCell.setCellStyle(totalCurrencyStyle);

    // Auto-size columns
    for (int i = 0; i < headers.length; i++) {
      sheet.autoSizeColumn(i);
    }

    // Write to byte array
    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
    workbook.write(outputStream);
    workbook.close();

    return outputStream.toByteArray();
  }

  // ========== PDF EXPORT ==========
  public byte[] exportExpensesToPDF(List<ExpenseEntity> expenses, String userName) throws IOException, DocumentException {

    Document document = new Document(PageSize.A4);
    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
    PdfWriter.getInstance(document, outputStream);

    document.open();

    // Add Title
    com.itextpdf.text.Font titlePdfFont = new com.itextpdf.text.Font(
        com.itextpdf.text.Font.FontFamily.HELVETICA,
        20,
        com.itextpdf.text.Font.BOLD,
        new com.itextpdf.text.BaseColor(52, 58, 64)
    );
    Paragraph title = new Paragraph("SpendWise - Expense Report", titlePdfFont);
    title.setAlignment(Element.ALIGN_CENTER);
    title.setSpacingAfter(10);
    document.add(title);

    // Add User Info
    com.itextpdf.text.Font normalPdfFont = new com.itextpdf.text.Font(
        com.itextpdf.text.Font.FontFamily.HELVETICA,
        12,
        com.itextpdf.text.Font.NORMAL,
        com.itextpdf.text.BaseColor.BLACK
    );
    Paragraph userInfo = new Paragraph("Generated for: " + userName, normalPdfFont);
    userInfo.setSpacingAfter(5);
    document.add(userInfo);

    Paragraph dateInfo = new Paragraph("Date: " + java.time.LocalDate.now(), normalPdfFont);
    dateInfo.setSpacingAfter(20);
    document.add(dateInfo);

    // Create table
    PdfPTable table = new PdfPTable(6);
    table.setWidthPercentage(100);
    table.setSpacingBefore(10f);
    table.setSpacingAfter(10f);

    // Set column widths
    float[] columnWidths = {1f, 2f, 3f, 2f, 2f, 2f};
    table.setWidths(columnWidths);

    // Table header
    com.itextpdf.text.Font headerPdfFont = new com.itextpdf.text.Font(
        com.itextpdf.text.Font.FontFamily.HELVETICA,
        10,
        com.itextpdf.text.Font.BOLD,
        com.itextpdf.text.BaseColor.WHITE
    );
    String[] pdfHeaders = {"ID", "Date", "Title", "Category", "Amount", "Status"};

    for (String header : pdfHeaders) {
      PdfPCell cell = new PdfPCell(new Phrase(header, headerPdfFont));
      cell.setBackgroundColor(new com.itextpdf.text.BaseColor(52, 58, 64));
      cell.setHorizontalAlignment(Element.ALIGN_CENTER);
      cell.setPadding(8);
      table.addCell(cell);
    }

    // Table data
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
    com.itextpdf.text.Font cellPdfFont = new com.itextpdf.text.Font(
        com.itextpdf.text.Font.FontFamily.HELVETICA,
        9,
        com.itextpdf.text.Font.NORMAL,
        com.itextpdf.text.BaseColor.BLACK
    );
    double totalAmount = 0;

    for (ExpenseEntity expense : expenses) {
      // ID
      PdfPCell idCell = new PdfPCell(new Phrase(String.valueOf(expense.getExpenseId()), cellPdfFont));
      idCell.setPadding(5);
      table.addCell(idCell);

      // Date
      String dateStr = expense.getTranscationDate() != null ?
          expense.getTranscationDate().format(dateFormatter) : "N/A";
      PdfPCell dateCell = new PdfPCell(new Phrase(dateStr, cellPdfFont));
      dateCell.setPadding(5);
      table.addCell(dateCell);

      // Title
      PdfPCell titleCell = new PdfPCell(new Phrase(expense.getTitle() != null ? expense.getTitle() : "", cellPdfFont));
      titleCell.setPadding(5);
      table.addCell(titleCell);

      // Category
      String category = "Category " + (expense.getCategoryId() != null ? expense.getCategoryId() : "N/A");
      PdfPCell catCell = new PdfPCell(new Phrase(category, cellPdfFont));
      catCell.setPadding(5);
      table.addCell(catCell);

      // Amount
      com.itextpdf.text.Font amountPdfFont = new com.itextpdf.text.Font(
          com.itextpdf.text.Font.FontFamily.HELVETICA,
          9,
          com.itextpdf.text.Font.BOLD,
          new com.itextpdf.text.BaseColor(238, 9, 121)
      );
      PdfPCell amountCell = new PdfPCell(new Phrase("$" + String.format("%.2f", expense.getAmount()), amountPdfFont));
      amountCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
      amountCell.setPadding(5);
      table.addCell(amountCell);

      // Status
      String status = expense.isStatus() ? "Active" : "Inactive";
      PdfPCell statusCell = new PdfPCell(new Phrase(status, cellPdfFont));
      statusCell.setPadding(5);
      table.addCell(statusCell);

      totalAmount += expense.getAmount();
    }

    // Add total row
    PdfPCell totalLabelCell = new PdfPCell(new Phrase("TOTAL:", headerPdfFont));
    totalLabelCell.setColspan(4);
    totalLabelCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
    totalLabelCell.setPadding(8);
    totalLabelCell.setBackgroundColor(com.itextpdf.text.BaseColor.LIGHT_GRAY);
    table.addCell(totalLabelCell);

    com.itextpdf.text.Font totalPdfFont = new com.itextpdf.text.Font(
        com.itextpdf.text.Font.FontFamily.HELVETICA,
        10,
        com.itextpdf.text.Font.BOLD,
        new com.itextpdf.text.BaseColor(238, 9, 121)
    );
    PdfPCell totalAmountCell = new PdfPCell(new Phrase("$" + String.format("%.2f", totalAmount), totalPdfFont));
    totalAmountCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
    totalAmountCell.setPadding(8);
    totalAmountCell.setBackgroundColor(com.itextpdf.text.BaseColor.LIGHT_GRAY);
    table.addCell(totalAmountCell);

    PdfPCell emptyCell = new PdfPCell(new Phrase(""));
    emptyCell.setBackgroundColor(com.itextpdf.text.BaseColor.LIGHT_GRAY);
    table.addCell(emptyCell);

    document.add(table);

    // Add footer
    com.itextpdf.text.Font footerPdfFont = new com.itextpdf.text.Font(
        com.itextpdf.text.Font.FontFamily.HELVETICA,
        8,
        com.itextpdf.text.Font.NORMAL,
        com.itextpdf.text.BaseColor.GRAY
    );
    Paragraph footer = new Paragraph("Generated by SpendWise Expense Tracker", footerPdfFont);
    footer.setAlignment(Element.ALIGN_CENTER);
    footer.setSpacingBefore(20);
    document.add(footer);

    document.close();

    return outputStream.toByteArray();
  }

  // ========== CSV EXPORT ==========
  public byte[] exportExpensesToCSV(List<ExpenseEntity> expenses) throws IOException {

    StringBuilder csv = new StringBuilder();
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    // CSV Header
    csv.append("ID,Date,Title,Category ID,Subcategory ID,Vendor ID,Account ID,Amount,Description,Status\n");

    // CSV Data
    for (ExpenseEntity expense : expenses) {
      csv.append(expense.getExpenseId()).append(",");
      csv.append(expense.getTranscationDate() != null ?
          expense.getTranscationDate().format(dateFormatter) : "N/A").append(",");
      csv.append("\"").append(expense.getTitle() != null ? expense.getTitle().replace("\"", "\"\"") : "").append("\",");
      csv.append(expense.getCategoryId() != null ? expense.getCategoryId() : "").append(",");
      csv.append(expense.getSubcategoryId() != null ? expense.getSubcategoryId() : "").append(",");
      csv.append(expense.getVendorId() != null ? expense.getVendorId() : "").append(",");
      csv.append(expense.getAccountId() != null ? expense.getAccountId() : "").append(",");
      csv.append(String.format("%.2f", expense.getAmount())).append(",");
      csv.append("\"").append(expense.getDescription() != null ?
          expense.getDescription().replace("\"", "\"\"") : "").append("\",");
      csv.append(expense.isStatus() ? "Active" : "Inactive").append("\n");
    }

    // Add total row
    double total = expenses.stream().mapToDouble(ExpenseEntity::getAmount).sum();
    csv.append(",,,,,,,").append(String.format("%.2f", total)).append(",,\n");
    csv.append(",,,,,TOTAL,$").append(String.format("%.2f", total)).append(",,\n");

    return csv.toString().getBytes();
  }

  // ========== JSON EXPORT ==========
  public byte[] exportExpensesToJSON(List<ExpenseEntity> expenses) throws IOException {

    StringBuilder json = new StringBuilder();
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss");

    json.append("{\n");
    json.append("  \"expenses\": [\n");

    for (int i = 0; i < expenses.size(); i++) {
      ExpenseEntity expense = expenses.get(i);

      json.append("    {\n");
      json.append("      \"id\": ").append(expense.getExpenseId()).append(",\n");
      json.append("      \"title\": \"").append(expense.getTitle() != null ? expense.getTitle() : "").append("\",\n");
      json.append("      \"amount\": ").append(expense.getAmount()).append(",\n");
      json.append("      \"categoryId\": ").append(expense.getCategoryId() != null ? expense.getCategoryId() : "null").append(",\n");
      json.append("      \"subcategoryId\": ").append(expense.getSubcategoryId() != null ? expense.getSubcategoryId() : "null").append(",\n");
      json.append("      \"vendorId\": ").append(expense.getVendorId() != null ? expense.getVendorId() : "null").append(",\n");
      json.append("      \"accountId\": ").append(expense.getAccountId() != null ? expense.getAccountId() : "null").append(",\n");
      json.append("      \"date\": \"").append(expense.getTranscationDate() != null ?
          expense.getTranscationDate().format(dateFormatter) : "").append("\",\n");
      json.append("      \"description\": \"").append(expense.getDescription() != null ? expense.getDescription() : "").append("\",\n");
      json.append("      \"status\": \"").append(expense.isStatus() ? "active" : "inactive").append("\"\n");
      json.append("    }");

      if (i < expenses.size() - 1) {
        json.append(",");
      }
      json.append("\n");
    }

    json.append("  ],\n");

    double total = expenses.stream().mapToDouble(ExpenseEntity::getAmount).sum();
    json.append("  \"summary\": {\n");
    json.append("    \"totalExpenses\": ").append(String.format("%.2f", total)).append(",\n");
    json.append("    \"count\": ").append(expenses.size()).append(",\n");
    json.append("    \"generatedDate\": \"").append(java.time.LocalDateTime.now().format(dateFormatter)).append("\"\n");
    json.append("  }\n");
    json.append("}\n");

    return json.toString().getBytes();
  }
}