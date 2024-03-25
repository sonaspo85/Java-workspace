package main.java.satisfy.modules;

import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.RegionUtil;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.w3c.dom.*;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.*;

public class ExcelOutput {
    private static Workbook workbook;

    private HashMap<String, List<HashMap<String, Object>>> parsedData = new HashMap<>();

    public HashMap<String, List<HashMap<String, Object>>> parsingXML(String xmlFilePath) {
        try {
            File xmlFile = new File(xmlFilePath);
            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc = dBuilder.parse(xmlFile);

            doc.getDocumentElement().normalize();

            HashMap<String, List<HashMap<String, Object>>> parsedData = new HashMap<>();

            NodeList totalList = doc.getElementsByTagName("total");
            parseData(totalList, "total", parsedData);

            NodeList competitivePriceList = doc.getElementsByTagName("competitive_price");
            parseData(competitivePriceList, "competitive_price", parsedData);

            NodeList safetyNodeList = doc.getElementsByTagName("safety");
            parseData(safetyNodeList, "safety", parsedData);

            NodeList satisfyNodeList = doc.getElementsByTagName("satisfy");
            parseData(satisfyNodeList, "satisfy", parsedData);

            NodeList automationNodeList = doc.getElementsByTagName("automation");
            parseData(automationNodeList, "automation", parsedData);

            NodeList qualityNodeList = doc.getElementsByTagName("quality");
            parseData(qualityNodeList, "quality", parsedData);

            NodeList delivery_complianceNodeList = doc.getElementsByTagName("delivery_compliance");
            parseData(delivery_complianceNodeList, "delivery_compliance", parsedData);

            return parsedData;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private void parseData(NodeList nodeList, String className, HashMap<String, List<HashMap<String, Object>>> parsedData) {
        List<HashMap<String, Object>> classDataList = new ArrayList<>();

        for (int i = 0; i < nodeList.getLength(); i++) {
            Element classElement = (Element) nodeList.item(i);
            String classAttr = classElement.getAttribute("class");

            if (classElement.getTagName().equals("total")) {
                NodeList divList = classElement.getElementsByTagName("div");

                for (int z = 0; z < divList.getLength(); z++) {
                    Element divElement = (Element) divList.item(z);
                    String ranking = divElement.getAttribute("ranking");
                    String total = divElement.getAttribute("total");
                    String filename = divElement.getAttribute("filename");

                    HashMap<String, Object> groupedData = new HashMap<>();
                    groupedData.put("ranking", ranking);
                    groupedData.put("total", total);
                    groupedData.put("filename", filename);

                    classDataList.add(groupedData);
                }
            } else if (classAttr.equals("견적금액")) {
                NodeList itemList = classElement.getElementsByTagName("item");

                for (int t = 0; t < itemList.getLength(); t++) {
                    Element itemElement = (Element) itemList.item(t);
                    String filename = itemElement.getAttribute("filename");
                    String percent = itemElement.getAttribute("percent");
                    String id = itemElement.getAttribute("id");
                    String t1cell1 = itemElement.getAttribute("t1cell1");
                    String t1cell2 = itemElement.getAttribute("t1cell2");
                    String t1cell3 = itemElement.getAttribute("t1cell3");
                    String t1cell4 = itemElement.getAttribute("t1cell4");
                    String result = itemElement.getAttribute("result");
                    String ranking = itemElement.getAttribute("ranking");

                    HashMap<String, Object> groupedData = new HashMap<>();
                    groupedData.put("filename", filename);
                    groupedData.put("id", id);
                    groupedData.put("t1cell1", t1cell1);
                    groupedData.put("t1cell2", t1cell2);
                    groupedData.put("t1cell3", t1cell3);
                    groupedData.put("t1cell4", t1cell4);
                    groupedData.put("result", result);
                    groupedData.put("ranking", ranking);

                    classDataList.add(groupedData);
                }
            } else if (classAttr.equals("만족도")) {
                NodeList itemsList = classElement.getElementsByTagName("items");
                for (int t = 0; t < itemsList.getLength(); t++) {
                    Element itemsElement = (Element) itemsList.item(t);
                    String filename = itemsElement.getAttribute("filename");
                    String percentage = itemsElement.getAttribute("percentage");
                    String score = itemsElement.getAttribute("result");
                    String sum = itemsElement.getAttribute("sum");
                    String ranking = itemsElement.getAttribute("ranking");

                    NodeList itemNodeList = itemsElement.getElementsByTagName("item");

                    LinkedHashSet <String> uniqueT6Cell1Set = new LinkedHashSet <>();
                    LinkedHashSet <String> idSet = new LinkedHashSet <>();

                    for (int m = 0; m < itemNodeList.getLength(); m++) {
                        Element itemElement = (Element) itemNodeList.item(m);
                        String id = itemElement.getAttribute("id");
                        String t6cell1 = itemElement.getAttribute("t6cell1");

                        if (!t6cell1.isEmpty()) {
                            uniqueT6Cell1Set.add(t6cell1);
                        }

                        if (!id.isEmpty()) {
                            idSet.add(id);
                        }

                    }

                    String uniqueT6Cell1 = String.join(": ", uniqueT6Cell1Set);
                    String idString = String.join(", ", idSet);

                    HashMap<String, Object> groupedData = new HashMap<>();
                    groupedData.put("uniqueT6Cell1", uniqueT6Cell1);
                    groupedData.put("id", idString);
                    groupedData.put("filename", filename);
                    groupedData.put("percentage", percentage);
                    groupedData.put("score", score);
                    groupedData.put("sum", sum);
                    groupedData.put("ranking", ranking);

                    classDataList.add(groupedData);
                }
            } else if (classAttr.equals("자동화")) {
                NodeList itemsList = classElement.getElementsByTagName("items");
                for (int t = 0; t < itemsList.getLength(); t++) {
                    Element itemsElement = (Element) itemsList.item(t);

                    String itemsClass = itemsElement.getAttribute("class");

                    NodeList itemNodeList = itemsElement.getElementsByTagName("item");

                    for (int m = 0; m < itemNodeList.getLength(); m++) {
                        Element itemElement = (Element) itemNodeList.item(m);
                        String percent = itemElement.getAttribute("percent");
                        String filename = itemElement.getAttribute("filename");
                        String id = itemElement.getAttribute("id");
                        String score = itemElement.getAttribute("score");
                        String t2cell2 = itemElement.getAttribute("t2cell2");
                        String t2cell3 = itemElement.getAttribute("t2cell3");
                        String t2cell4 = itemElement.getAttribute("t2cell4");
                        String t2cell5 = itemElement.getAttribute("t2cell5");
                        String ranking = itemElement.getAttribute("ranking");

                        HashMap<String, Object> groupedData = new HashMap<>();
                        groupedData.put("itemsClass", itemsClass);
                        groupedData.put("percent", percent);
                        groupedData.put("filename", filename);
                        groupedData.put("id", id);
                        groupedData.put("score", score);
                        groupedData.put("t2cell2", t2cell2);
                        groupedData.put("t2cell3", t2cell3);
                        groupedData.put("t2cell4", t2cell4);
                        groupedData.put("t2cell5", t2cell5);
                        groupedData.put("ranking", ranking);

                        classDataList.add(groupedData);
                    }

                }
            } else if (classAttr.equals("결과물 품질")) {
                NodeList itemsList = classElement.getElementsByTagName("items");
                for (int t = 0; t < itemsList.getLength(); t++) {
                    Element itemsElement = (Element) itemsList.item(t);

                    String itemsClass = itemsElement.getAttribute("class");

                    NodeList itemNodeList = itemsElement.getElementsByTagName("item");

                    for (int m = 0; m < itemNodeList.getLength(); m++) {
                        Element itemElement = (Element) itemNodeList.item(m);
                        String percent = itemElement.getAttribute("percent");
                        String filename = itemElement.getAttribute("filename");
                        String id = itemElement.getAttribute("id");
                        String t4cell2 = itemElement.getAttribute("t4cell2");
                        String t4cell3 = itemElement.getAttribute("t4cell3");
                        String t4cell4 = itemElement.getAttribute("t4cell4");
                        String t4cell5 = itemElement.getAttribute("t4cell5");
                        String score = itemElement.getAttribute("score");
                        String ranking = itemElement.getAttribute("ranking");

                        HashMap<String, Object> groupedData = new HashMap<>();
                        groupedData.put("itemsClass", itemsClass);
                        groupedData.put("percent", percent);
                        groupedData.put("filename", filename);
                        groupedData.put("id", id);
                        groupedData.put("score", score);
                        groupedData.put("t4cell2", t4cell2);
                        groupedData.put("t4cell3", t4cell3);
                        groupedData.put("t4cell4", t4cell4);
                        groupedData.put("t4cell5", t4cell5);
                        groupedData.put("ranking", ranking);

                        classDataList.add(groupedData);
                    }
                }
            } else if (classAttr.equals("납기 준수율")) {
                NodeList itemList = classElement.getElementsByTagName("item");

                for (int t = 0; t < itemList.getLength(); t++) {
                    Element itemElement = (Element) itemList.item(t);
                    String filename = itemElement.getAttribute("filename");
                    String percent = itemElement.getAttribute("percent");
                    String id = itemElement.getAttribute("id");
                    String t5cell1 = itemElement.getAttribute("t5cell1");
                    String t5cell2 = itemElement.getAttribute("t5cell2");
                    String t5cell3 = itemElement.getAttribute("t5cell3");
                    String t5cell4 = itemElement.getAttribute("t5cell4");
                    String t5cell5 = itemElement.getAttribute("t5cell5");
                    String score = itemElement.getAttribute("score");
                    String ranking = itemElement.getAttribute("ranking");

                    HashMap<String, Object> groupedData = new HashMap<>();
                    groupedData.put("filename", filename);
                    groupedData.put("percent", percent);
                    groupedData.put("id", id);
                    groupedData.put("t5cell1", t5cell1);
                    groupedData.put("t5cell2", t5cell2);
                    groupedData.put("t5cell3", t5cell3);
                    groupedData.put("t5cell4", t5cell4);
                    groupedData.put("t5cell5", t5cell5);
                    groupedData.put("score", score);
                    groupedData.put("ranking", ranking);

                    classDataList.add(groupedData);
                }
            } else if (classAttr.equals("보안")) {
                NodeList groupedsList = classElement.getElementsByTagName("grouped");

                for (int j = 0; j < groupedsList.getLength(); j++) {
                    Element groupedsElement = (Element) groupedsList.item(j);
                    String groupedsClassAttr = groupedsElement.getAttribute("class");

                    NodeList itemsList = groupedsElement.getElementsByTagName("items");
                    List<HashMap<String, Object>> itemsClassList = new ArrayList<>();

                    for (int k = 0; k < itemsList.getLength(); k++) {
                        Element itemsElement = (Element) itemsList.item(k);
                        String itemsClassAttr = itemsElement.getAttribute("class");
                        NodeList itemNodeList = itemsElement.getElementsByTagName("item");
                        List<HashMap<String, Object>> itemList = new ArrayList<>();
                        for (int m = 0; m < itemNodeList.getLength(); m++) {
                            Element itemElement = (Element) itemNodeList.item(m);
                            String filename = itemElement.getAttribute("filename");
                            String percent = itemElement.getAttribute("percent");
                            String id = itemElement.getAttribute("id");
                            String t3cell3 = itemElement.getAttribute("t3cell3");
                            String t3cell4 = itemElement.getAttribute("t3cell4");
                            String result = itemElement.getAttribute("result");
                            String score = itemElement.getAttribute("score");
                            String ranking = itemElement.getAttribute("ranking");

                            HashMap<String, Object> itemData = new HashMap<>();

                            itemData.put("filename", filename);
                            itemData.put("percent", percent);
                            itemData.put("id", id);
                            itemData.put("t3cell3", t3cell3);
                            itemData.put("t3cell4", t3cell4);
                            itemData.put("result", result);
                            itemData.put("score", score);
                            itemData.put("ranking", ranking);
                            itemList.add(itemData);
                        }
                        HashMap<String, Object> itemsClassData = new HashMap<>();
                        itemsClassData.put("class", itemsClassAttr);
                        itemsClassData.put("items", itemList);

                        itemsClassList.add(itemsClassData);
                    }
                    HashMap<String, Object> groupedData = new HashMap<>();
                    groupedData.put("class", groupedsClassAttr);
                    groupedData.put(groupedsClassAttr, itemsClassList);

                    classDataList.add(groupedData);
                }
            }
        }
        parsedData.put(className, classDataList);

    }
    public static void createExcelFile(HashMap<String, List<HashMap<String, Object>>> parsedData, String filePath) {
        workbook = new XSSFWorkbook();
        CellStyle headerStyle = createHeaderStyle(workbook);
        CellStyle thinCellStyle = createCellStyle(workbook);

        //업체 총점 및 순위
        int totalRowP = 2;
        Sheet totalSheet = workbook.createSheet("업체 총점 및 순위");

        Row totalHeaderRowP = totalSheet.createRow(totalRowP++);
        totalHeaderRowP.createCell(1).setCellValue("구분");
        totalHeaderRowP.getCell(1).setCellStyle(headerStyle);
        totalHeaderRowP.createCell(2).setCellValue("업체 총점 및 순위");
        totalHeaderRowP.getCell(2).setCellStyle(headerStyle);

        Row totalRow = totalSheet.createRow(totalRowP++);
        totalRow.createCell(1).setCellValue("업체명");
        totalRow.getCell(1).setCellStyle(headerStyle);
        totalRow.createCell(2).setCellValue("총점");
        totalRow.getCell(2).setCellStyle(headerStyle);
        totalRow.createCell(3).setCellValue("업체 순위");
        totalRow.getCell(3).setCellStyle(headerStyle);

        CellRangeAddress totalRegion = new CellRangeAddress(2,2,2,3);
        totalSheet.addMergedRegion(totalRegion);
        setRegionBorder(BorderStyle.THIN, totalRegion, totalSheet, workbook);

        int rowNum = 2; // Start from the next row after the header
        Sheet biddingSheet = workbook.createSheet("Bidding 금액");
        Row priceHeaderRowP = biddingSheet.createRow(rowNum++);
        priceHeaderRowP.createCell(1).setCellValue("구분");
        priceHeaderRowP.getCell(1).setCellStyle(headerStyle);
        priceHeaderRowP.createCell(2).setCellValue("가격 경쟁력");
        priceHeaderRowP.getCell(2).setCellStyle(headerStyle);

        Row priceRow = biddingSheet.createRow(rowNum++);
        priceRow.createCell(1).setCellValue("업체명");
        priceRow.getCell(1).setCellStyle(headerStyle);
        priceRow.createCell(2).setCellValue("과제/업무별 업체 입찰금액 가중치");
        priceRow.getCell(2).setCellStyle(headerStyle);
        priceRow.createCell(3).setCellValue("과제/업무별 업체 입찰금액");
        priceRow.getCell(3).setCellStyle(headerStyle);
        priceRow.createCell(4).setCellValue("배점");
        priceRow.getCell(4).setCellStyle(headerStyle);
        priceRow.createCell(5).setCellValue("우선 순위 업체");
        priceRow.getCell(5).setCellStyle(headerStyle);

        CellRangeAddress biddingRegion = new CellRangeAddress(2,2,2,5);
        biddingSheet.addMergedRegion(biddingRegion);
        setRegionBorder(BorderStyle.THIN, biddingRegion, biddingSheet, workbook);

        int satisfyRowP = 2;
        Sheet satisfySheet = workbook.createSheet("만족도");
        Row satisfyHeaderRow = satisfySheet.createRow(satisfyRowP++);
        satisfyHeaderRow.createCell(1).setCellValue("구분");
        satisfyHeaderRow.getCell(1).setCellStyle(headerStyle);
        satisfyHeaderRow.createCell(2).setCellValue("수행도");
        satisfyHeaderRow.getCell(2).setCellStyle(headerStyle);
        Row satisfyRow = satisfySheet.createRow(satisfyRowP++);
        satisfyRow.createCell(1).setCellValue("업체명");
        satisfyRow.getCell(1).setCellStyle(headerStyle);
        satisfyRow.createCell(2).setCellValue("배점");
        satisfyRow.getCell(2).setCellStyle(headerStyle);
        satisfyRow.createCell(3).setCellValue("결과");
        satisfyRow.getCell(3).setCellStyle(headerStyle);
        satisfyRow.createCell(4).setCellValue("업체 순위");
        satisfyRow.getCell(4).setCellStyle(headerStyle);

        CellRangeAddress satisfyRegion = new CellRangeAddress(2,2,2,4);
        satisfySheet.addMergedRegion(satisfyRegion);
        setRegionBorder(BorderStyle.THIN, satisfyRegion, satisfySheet, workbook);

        int satisfyRowP2 = 8;
        Row satisfyHeaderRow2 = satisfySheet.createRow(satisfyRowP2++);
        satisfyHeaderRow2.createCell(1).setCellValue("ID");
        satisfyHeaderRow2.getCell(1).setCellStyle(headerStyle);
        satisfyHeaderRow2.createCell(2).setCellValue("항목");
        satisfyHeaderRow2.getCell(2).setCellStyle(headerStyle);

        CellRangeAddress satisfy2Region = new CellRangeAddress(8,8,2,4);
        satisfySheet.addMergedRegion(satisfy2Region);
        setRegionBorder(BorderStyle.THIN, satisfy2Region, satisfySheet, workbook);

        int automationRowP = 2;
        Sheet automationSheet = workbook.createSheet("자동화");
        Row automationHeaderRow = automationSheet.createRow(automationRowP++);
        automationHeaderRow.createCell(1).setCellValue("구분");
        automationHeaderRow.getCell(1).setCellStyle(headerStyle);
        automationHeaderRow.createCell(2).setCellValue("現 보유중인 자동화툴/프로그램 개수");
        automationHeaderRow.getCell(2).setCellStyle(headerStyle);

        Row automationRow = automationSheet.createRow(automationRowP++);
        automationRow.createCell(1).setCellValue("업체명");
        automationRow.getCell(1).setCellStyle(headerStyle);
        automationRow.createCell(2).setCellValue("직전 툴 수");
        automationRow.getCell(2).setCellStyle(headerStyle);
        automationRow.createCell(3).setCellValue("현재 툴 수");
        automationRow.getCell(3).setCellStyle(headerStyle);
        automationRow.createCell(4).setCellValue("배점");
        automationRow.getCell(4).setCellStyle(headerStyle);
        automationRow.createCell(5).setCellValue("결과");
        automationRow.getCell(5).setCellStyle(headerStyle);
        automationRow.createCell(6).setCellValue("업체 순위");
        automationRow.getCell(6).setCellStyle(headerStyle);

        CellRangeAddress automationRegion1 = new CellRangeAddress(2,2,2,6);
        automationSheet.addMergedRegion(automationRegion1);
        setRegionBorder(BorderStyle.THIN, automationRegion1, automationSheet, workbook);

        int automationRowP2 = 8;
        Row automationHeaderRow2 = automationSheet.createRow(automationRowP2++);
        automationHeaderRow2.createCell(1).setCellValue("구분");
        automationHeaderRow2.getCell(1).setCellStyle(headerStyle);
        automationHeaderRow2.createCell(2).setCellValue("직전 과제 대비 자동화 툴/프로그램 추가 개수");
        automationHeaderRow2.getCell(2).setCellStyle(headerStyle);

        Row automationRow2 = automationSheet.createRow(automationRowP2++);
        automationRow2.createCell(1).setCellValue("업체명");
        automationRow2.getCell(1).setCellStyle(headerStyle);
        automationRow2.createCell(2).setCellValue("직전 툴 수");
        automationRow2.getCell(2).setCellStyle(headerStyle);
        automationRow2.createCell(3).setCellValue("현재 툴 수");
        automationRow2.getCell(3).setCellStyle(headerStyle);
        automationRow2.createCell(4).setCellValue("배점");
        automationRow2.getCell(4).setCellStyle(headerStyle);
        automationRow2.createCell(5).setCellValue("결과");
        automationRow2.getCell(5).setCellStyle(headerStyle);
        automationRow2.createCell(6).setCellValue("업체 순위");
        automationRow2.getCell(6).setCellStyle(headerStyle);

        CellRangeAddress automationRegion2 = new CellRangeAddress(8,8,2,6);
        automationSheet.addMergedRegion(automationRegion2);
        setRegionBorder(BorderStyle.THIN, automationRegion2, automationSheet, workbook);

        Sheet qualitySheet = workbook.createSheet("결과물 품질");
        int qualityRowP = 2;
        Row qualityHeaderRow = qualitySheet.createRow(qualityRowP++);
        qualityHeaderRow.createCell(1).setCellValue("구분");
        qualityHeaderRow.getCell(1).setCellStyle(headerStyle);
        qualityHeaderRow.createCell(2).setCellValue("결과물 품질(직전과제 오류건 / 연간 진행 종수)");
        qualityHeaderRow.getCell(2).setCellStyle(headerStyle);
        Row qualityRow = qualitySheet.createRow(qualityRowP++);
        qualityRow.createCell(1).setCellValue("업체명");
        qualityRow.getCell(1).setCellStyle(headerStyle);
        qualityRow.createCell(2).setCellValue("직전 오류 수");
        qualityRow.getCell(2).setCellStyle(headerStyle);
        qualityRow.createCell(3).setCellValue("진행 종수");
        qualityRow.getCell(3).setCellStyle(headerStyle);
        qualityRow.createCell(4).setCellValue("배점");
        qualityRow.getCell(4).setCellStyle(headerStyle);
        qualityRow.createCell(5).setCellValue("결과");
        qualityRow.getCell(5).setCellStyle(headerStyle);
        qualityRow.createCell(6).setCellValue("업체 순위");
        qualityRow.getCell(6).setCellStyle(headerStyle);

        CellRangeAddress qualityRegion1 = new CellRangeAddress(2,2,2,6);
        qualitySheet.addMergedRegion(qualityRegion1);
        setRegionBorder(BorderStyle.THIN, qualityRegion1, qualitySheet, workbook);

        int qualityRowP2 = 8;
        Row qualityHeaderRow2 = qualitySheet.createRow(qualityRowP2++);
        qualityHeaderRow2.createCell(1).setCellValue("구분");
        qualityHeaderRow2.getCell(1).setCellStyle(headerStyle);
        qualityHeaderRow2.createCell(2).setCellValue("결과물 품질(S급 오류 개수)");
        qualityHeaderRow2.getCell(2).setCellStyle(headerStyle);
        Row qualityRow2 = qualitySheet.createRow(qualityRowP2++);
        qualityRow2.createCell(1).setCellValue("업체명");
        qualityRow2.getCell(1).setCellStyle(headerStyle);
        qualityRow2.createCell(2).setCellValue("직전 오류 수");
        qualityRow2.getCell(2).setCellStyle(headerStyle);
        qualityRow2.createCell(3).setCellValue("진행 종수");
        qualityRow2.getCell(3).setCellStyle(headerStyle);
        qualityRow2.createCell(4).setCellValue("배점");
        qualityRow2.getCell(4).setCellStyle(headerStyle);
        qualityRow2.createCell(5).setCellValue("결과");
        qualityRow2.getCell(5).setCellStyle(headerStyle);
        qualityRow2.createCell(6).setCellValue("업체 순위");
        qualityRow2.getCell(6).setCellStyle(headerStyle);

        CellRangeAddress qualityRegion2 = new CellRangeAddress(8,8,2,6);
        qualitySheet.addMergedRegion(qualityRegion2);
        setRegionBorder(BorderStyle.THIN, qualityRegion2, qualitySheet, workbook);

        //납기 준수율
        Sheet delivery_complianceSheet = workbook.createSheet("납기 준수율");
        int delivery_complianceSheetRowP = 2;
        Row delivery_complianceHeaderRow = delivery_complianceSheet.createRow(delivery_complianceSheetRowP++);
        delivery_complianceHeaderRow.createCell(1).setCellValue("구분");
        delivery_complianceHeaderRow.getCell(1).setCellStyle(headerStyle);
        delivery_complianceHeaderRow.createCell(2).setCellValue("납기 준수율");
        delivery_complianceHeaderRow.getCell(2).setCellStyle(headerStyle);
        Row delivery_complianceRow = delivery_complianceSheet.createRow(delivery_complianceSheetRowP++);
        delivery_complianceRow.createCell(1).setCellValue("평가 항목");
        delivery_complianceRow.getCell(1).setCellStyle(headerStyle);
        delivery_complianceRow.createCell(2).setCellValue("직전 지연 수");
        delivery_complianceRow.getCell(2).setCellStyle(headerStyle);
        delivery_complianceRow.createCell(3).setCellValue("진행 종수");
        delivery_complianceRow.getCell(3).setCellStyle(headerStyle);
        delivery_complianceRow.createCell(4).setCellValue("배점");
        delivery_complianceRow.getCell(4).setCellStyle(headerStyle);
        delivery_complianceRow.createCell(5).setCellValue("결과");
        delivery_complianceRow.getCell(5).setCellStyle(headerStyle);
        delivery_complianceRow.createCell(6).setCellValue("업체 순위");
        delivery_complianceRow.getCell(6).setCellStyle(headerStyle);

        CellRangeAddress delivery_complianceRegion1 = new CellRangeAddress(2,2,2,6);
        delivery_complianceSheet.addMergedRegion(delivery_complianceRegion1);
        setRegionBorder(BorderStyle.THIN, delivery_complianceRegion1, delivery_complianceSheet, workbook);

        Sheet securitySheet = workbook.createSheet("보안");
        int securityRowP1 = 2;
        Row securityHeaderRow = securitySheet.createRow(securityRowP1++);
        securityHeaderRow.createCell(1).setCellValue("구분");
        securityHeaderRow.getCell(1).setCellStyle(headerStyle);
        securityHeaderRow.createCell(2).setCellValue("보안(보안룸 별도 운영 및 관리 여부)");
        securityHeaderRow.getCell(2).setCellStyle(headerStyle);
        Row securityRow = securitySheet.createRow(securityRowP1++);
        securityRow.createCell(1).setCellValue("업체명");
        securityRow.getCell(1).setCellStyle(headerStyle);
        securityRow.createCell(2).setCellValue("평가항목");
        securityRow.getCell(2).setCellStyle(headerStyle);
        securityRow.createCell(3).setCellValue("O/X");
        securityRow.getCell(3).setCellStyle(headerStyle);
        securityRow.createCell(4).setCellValue("배점");
        securityRow.getCell(4).setCellStyle(headerStyle);
        securityRow.createCell(5).setCellValue("결과");
        securityRow.getCell(5).setCellStyle(headerStyle);

        CellRangeAddress securityRegion1 = new CellRangeAddress(2,2,2,5);
        securitySheet.addMergedRegion(securityRegion1);
        setRegionBorder(BorderStyle.THIN, securityRegion1, securitySheet, workbook);

        int securityRowP2 = 8;
        Row securityHeaderRow2 = securitySheet.createRow(securityRowP2++);
        securityHeaderRow2.createCell(1).setCellValue("구분");
        securityHeaderRow2.getCell(1).setCellStyle(headerStyle);
        securityHeaderRow2.createCell(2).setCellValue("보안(보안룸 별도 운영 및 관리 여부)");
        securityHeaderRow2.getCell(2).setCellStyle(headerStyle);
        Row securityRow2 = securitySheet.createRow(securityRowP2++);
        securityRow2.createCell(1).setCellValue("업체명");
        securityRow2.getCell(1).setCellStyle(headerStyle);
        securityRow2.createCell(2).setCellValue("평가항목");
        securityRow2.getCell(2).setCellStyle(headerStyle);
        securityRow2.createCell(3).setCellValue("O/X");
        securityRow2.getCell(3).setCellStyle(headerStyle);
        securityRow2.createCell(4).setCellValue("배점");
        securityRow2.getCell(4).setCellStyle(headerStyle);
        securityRow2.createCell(5).setCellValue("결과");
        securityRow2.getCell(5).setCellStyle(headerStyle);

        CellRangeAddress securityRegion2 = new CellRangeAddress(8,8,2,5);
        securitySheet.addMergedRegion(securityRegion2);
        setRegionBorder(BorderStyle.THIN, securityRegion2, securitySheet, workbook);

        int securityRowP3 = 14;
        Row securityHeaderRow3 = securitySheet.createRow(securityRowP3++);
        securityHeaderRow3.createCell(1).setCellValue("구분");
        securityHeaderRow3.getCell(1).setCellStyle(headerStyle);
        securityHeaderRow3.createCell(2).setCellValue("보안(보안룸 별도 운영 및 관리 여부)");
        securityHeaderRow3.getCell(2).setCellStyle(headerStyle);
        Row securityRow3 = securitySheet.createRow(securityRowP3++);
        securityRow3.createCell(1).setCellValue("업체명");
        securityRow3.getCell(1).setCellStyle(headerStyle);
        securityRow3.createCell(2).setCellValue("평가항목");
        securityRow3.getCell(2).setCellStyle(headerStyle);
        securityRow3.createCell(3).setCellValue("O/X");
        securityRow3.getCell(3).setCellStyle(headerStyle);
        securityRow3.createCell(4).setCellValue("배점");
        securityRow3.getCell(4).setCellStyle(headerStyle);
        securityRow3.createCell(5).setCellValue("결과");
        securityRow3.getCell(5).setCellStyle(headerStyle);

        CellRangeAddress securityRegion3 = new CellRangeAddress(14,14,2,5);
        securitySheet.addMergedRegion(securityRegion3);
        setRegionBorder(BorderStyle.THIN, securityRegion3, securitySheet, workbook);

        int security2RowP1 = 20;
        Row security2HeaderRow = securitySheet.createRow(security2RowP1++);
        security2HeaderRow.createCell(1).setCellValue("구분");
        security2HeaderRow.getCell(1).setCellStyle(headerStyle);
        security2HeaderRow.createCell(2).setCellValue("보안(보안룸내 별도 네트워크 운영 및 관리)");
        security2HeaderRow.getCell(2).setCellStyle(headerStyle);
        Row security2Row = securitySheet.createRow(security2RowP1++);
        security2Row.createCell(1).setCellValue("업체명");
        security2Row.getCell(1).setCellStyle(headerStyle);
        security2Row.createCell(2).setCellValue("평가항목");
        security2Row.getCell(2).setCellStyle(headerStyle);
        security2Row.createCell(3).setCellValue("O/X");
        security2Row.getCell(3).setCellStyle(headerStyle);
        security2Row.createCell(4).setCellValue("배점");
        security2Row.getCell(4).setCellStyle(headerStyle);
        security2Row.createCell(5).setCellValue("결과");
        security2Row.getCell(5).setCellStyle(headerStyle);

        CellRangeAddress securityRegion4 = new CellRangeAddress(20,20,2,5);
        securitySheet.addMergedRegion(securityRegion4);
        setRegionBorder(BorderStyle.THIN, securityRegion4, securitySheet, workbook);

        int security2RowP2 = 26;
        Row security2HeaderRow2 = securitySheet.createRow(security2RowP2++);
        security2HeaderRow2.createCell(1).setCellValue("구분");
        security2HeaderRow2.getCell(1).setCellStyle(headerStyle);
        security2HeaderRow2.createCell(2).setCellValue("보안(보안룸내 별도 네트워크 운영 및 관리)");
        security2HeaderRow2.getCell(2).setCellStyle(headerStyle);
        Row security2Row2 = securitySheet.createRow(security2RowP2++);
        security2Row2.createCell(1).setCellValue("업체명");
        security2Row2.getCell(1).setCellStyle(headerStyle);
        security2Row2.createCell(2).setCellValue("평가항목");
        security2Row2.getCell(2).setCellStyle(headerStyle);
        security2Row2.createCell(3).setCellValue("O/X");
        security2Row2.getCell(3).setCellStyle(headerStyle);
        security2Row2.createCell(4).setCellValue("배점");
        security2Row2.getCell(4).setCellStyle(headerStyle);
        security2Row2.createCell(5).setCellValue("결과");
        security2Row2.getCell(5).setCellStyle(headerStyle);

        CellRangeAddress securityRegion5 = new CellRangeAddress(26,26,2,5);
        securitySheet.addMergedRegion(securityRegion5);
        setRegionBorder(BorderStyle.THIN, securityRegion5, securitySheet, workbook);

        int security2RowP3 = 32;
        Row security2HeaderRow3 = securitySheet.createRow(security2RowP3++);
        security2HeaderRow3.createCell(1).setCellValue("구분");
        security2HeaderRow3.getCell(1).setCellStyle(headerStyle);
        security2HeaderRow3.createCell(2).setCellValue("보안(보안룸내 별도 네트워크 운영 및 관리)");
        security2HeaderRow3.getCell(2).setCellStyle(headerStyle);
        Row security2Row3 = securitySheet.createRow(security2RowP3++);
        security2Row3.createCell(1).setCellValue("업체명");
        security2Row3.getCell(1).setCellStyle(headerStyle);
        security2Row3.createCell(2).setCellValue("평가항목");
        security2Row3.getCell(2).setCellStyle(headerStyle);
        security2Row3.createCell(3).setCellValue("O/X");
        security2Row3.getCell(3).setCellStyle(headerStyle);
        security2Row3.createCell(4).setCellValue("배점");
        security2Row3.getCell(4).setCellStyle(headerStyle);
        security2Row3.createCell(5).setCellValue("결과");
        security2Row3.getCell(5).setCellStyle(headerStyle);

        CellRangeAddress securityRegion6 = new CellRangeAddress(32,32,2,5);
        securitySheet.addMergedRegion(securityRegion6);
        setRegionBorder(BorderStyle.THIN, securityRegion6, securitySheet, workbook);

        int security3RowP1 = 38;
        Row security3HeaderRow = securitySheet.createRow(security3RowP1++);
        security3HeaderRow.createCell(1).setCellValue("구분");
        security3HeaderRow.getCell(1).setCellStyle(headerStyle);
        security3HeaderRow.createCell(2).setCellValue("보안(보안 교육 관리)");
        security3HeaderRow.getCell(2).setCellStyle(headerStyle);
        Row security3Row = securitySheet.createRow(security3RowP1++);
        security3Row.createCell(1).setCellValue("업체명");
        security3Row.getCell(1).setCellStyle(headerStyle);
        security3Row.createCell(2).setCellValue("평가항목");
        security3Row.getCell(2).setCellStyle(headerStyle);
        security3Row.createCell(3).setCellValue("O/X");
        security3Row.getCell(3).setCellStyle(headerStyle);
        security3Row.createCell(4).setCellValue("배점");
        security3Row.getCell(4).setCellStyle(headerStyle);
        security3Row.createCell(5).setCellValue("결과");
        security3Row.getCell(5).setCellStyle(headerStyle);

        CellRangeAddress securityRegion7 = new CellRangeAddress(38,38,2,5);
        securitySheet.addMergedRegion(securityRegion7);
        setRegionBorder(BorderStyle.THIN, securityRegion7, securitySheet, workbook);

        int security3RowP2 = 44;
        Row security3HeaderRow2 = securitySheet.createRow(security3RowP2++);
        security3HeaderRow2.createCell(1).setCellValue("구분");
        security3HeaderRow2.getCell(1).setCellStyle(headerStyle);
        security3HeaderRow2.createCell(2).setCellValue("보안(보안룸내 별도 네트워크 운영 및 관리)");
        security3HeaderRow2.getCell(2).setCellStyle(headerStyle);
        Row security3Row2 = securitySheet.createRow(security3RowP2++);
        security3Row2.createCell(1).setCellValue("업체명");
        security3Row2.getCell(1).setCellStyle(headerStyle);
        security3Row2.createCell(2).setCellValue("평가항목");
        security3Row2.getCell(2).setCellStyle(headerStyle);
        security3Row2.createCell(3).setCellValue("O/X");
        security3Row2.getCell(3).setCellStyle(headerStyle);
        security3Row2.createCell(4).setCellValue("배점");
        security3Row2.getCell(4).setCellStyle(headerStyle);
        security3Row2.createCell(5).setCellValue("결과");
        security3Row2.getCell(5).setCellStyle(headerStyle);

        CellRangeAddress securityRegion8 = new CellRangeAddress(44,44,2,5);
        securitySheet.addMergedRegion(securityRegion8);
        setRegionBorder(BorderStyle.THIN, securityRegion8, securitySheet, workbook);

        int security3RowP3 = 50;
        Row security3HeaderRow3 = securitySheet.createRow(security3RowP3++);
        security3HeaderRow3.createCell(1).setCellValue("구분");
        security3HeaderRow3.getCell(1).setCellStyle(headerStyle);
        security3HeaderRow3.createCell(2).setCellValue("보안(보안룸내 별도 네트워크 운영 및 관리)");
        security3HeaderRow3.getCell(2).setCellStyle(headerStyle);
        Row security3Row3 = securitySheet.createRow(security3RowP3++);
        security3Row3.createCell(1).setCellValue("업체명");
        security3Row3.getCell(1).setCellStyle(headerStyle);
        security3Row3.createCell(2).setCellValue("평가항목");
        security3Row3.getCell(2).setCellStyle(headerStyle);
        security3Row3.createCell(3).setCellValue("O/X");
        security3Row3.getCell(3).setCellStyle(headerStyle);
        security3Row3.createCell(4).setCellValue("배점");
        security3Row3.getCell(4).setCellStyle(headerStyle);
        security3Row3.createCell(5).setCellValue("결과");
        security3Row3.getCell(5).setCellStyle(headerStyle);

        CellRangeAddress securityRegion9 = new CellRangeAddress(50,50,2,5);
        securitySheet.addMergedRegion(securityRegion9);
        setRegionBorder(BorderStyle.THIN, securityRegion9, securitySheet, workbook);

        for (Map.Entry<String, List<HashMap<String, Object>>> entry : parsedData.entrySet()) {
            String className = entry.getKey();

            if (className.equals("safety")) {
                List<HashMap<String, Object>> classDataList = entry.getValue();

                for (HashMap<String, Object> groupData : classDataList) {
                    String groupClass = (String) groupData.get("class");
                    if (groupClass.equals("보안룸 별도 운영 및 관리 여부")) {
                        // Access "items" directly, assuming it's always present
                        List<HashMap<String, Object>> itemsClassList = (List<HashMap<String, Object>>) groupData.get(groupClass);

                        if (itemsClassList != null) {
                            for (HashMap<String, Object> itemsClassData : itemsClassList) {
                                String itemClassAttr = itemsClassData.get("class").toString();
                                List<HashMap<String, Object>> itemList = (List<HashMap<String, Object>>) itemsClassData.get("items");

                                if (itemClassAttr.equals("시건 장치 및 24시간 CCTV 가동여부")) {
                                    if (itemList != null) {
                                        for (HashMap<String, Object> itemData : itemList) {
                                            Row dataRow = securitySheet.createRow(securityRowP1++);
                                            dataRow.createCell(1).setCellValue((String) itemData.get("filename"));
                                            dataRow.getCell(1).setCellStyle(headerStyle);
                                            dataRow.createCell(2).setCellValue(itemClassAttr);
                                            dataRow.getCell(2).setCellStyle(thinCellStyle);
                                            dataRow.createCell(3).setCellValue((String) itemData.get("t3cell4"));
                                            dataRow.getCell(3).setCellStyle(thinCellStyle);
                                            dataRow.createCell(4).setCellValue((String) itemData.get("score"));
                                            dataRow.getCell(4).setCellStyle(thinCellStyle);
                                            dataRow.createCell(5).setCellValue((String) itemData.get("ranking"));
                                            dataRow.getCell(5).setCellStyle(thinCellStyle);
                                            // Add more cells as needed
                                        }
                                    }
                                } else if (itemClassAttr.equals("보안룸 출입 시 인력관리 및 절차여부")) {
                                    if (itemList != null) {
                                        for (HashMap<String, Object> itemData : itemList) {
                                            Row dataRow = securitySheet.createRow(securityRowP2++);
                                            dataRow.createCell(1).setCellValue((String) itemData.get("filename"));
                                            dataRow.getCell(1).setCellStyle(headerStyle);
                                            dataRow.createCell(2).setCellValue(itemClassAttr);
                                            dataRow.getCell(2).setCellStyle(thinCellStyle);
                                            dataRow.createCell(3).setCellValue((String) itemData.get("t3cell4"));
                                            dataRow.getCell(3).setCellStyle(thinCellStyle);
                                            dataRow.createCell(4).setCellValue((String) itemData.get("score"));
                                            dataRow.getCell(4).setCellStyle(thinCellStyle);
                                            dataRow.createCell(5).setCellValue((String) itemData.get("ranking"));
                                            dataRow.getCell(5).setCellStyle(thinCellStyle);
                                            // Add more cells as needed
                                        }
                                    }
                                } else if (itemClassAttr.equals("개발시료 배포 절차여부")) {
                                    if (itemList != null) {
                                        for (HashMap<String, Object> itemData : itemList) {
                                            Row dataRow = securitySheet.createRow(securityRowP3++);
                                            dataRow.createCell(1).setCellValue((String) itemData.get("filename"));
                                            dataRow.getCell(1).setCellStyle(headerStyle);
                                            dataRow.createCell(2).setCellValue(itemClassAttr);
                                            dataRow.getCell(2).setCellStyle(thinCellStyle);
                                            dataRow.createCell(3).setCellValue((String) itemData.get("t3cell4"));
                                            dataRow.getCell(3).setCellStyle(thinCellStyle);
                                            dataRow.createCell(4).setCellValue((String) itemData.get("score"));
                                            dataRow.getCell(4).setCellStyle(thinCellStyle);
                                            dataRow.createCell(5).setCellValue((String) itemData.get("ranking"));
                                            dataRow.getCell(5).setCellStyle(thinCellStyle);
                                            // Add more cells as needed
                                        }
                                    }
                                }
                            }
                        }
                    } else if (groupClass.equals("보안룸내 별도 네트워크 운영 및 관리")) {
                        // Access "items" directly, assuming it's always present
                        List<HashMap<String, Object>> itemsClassList = (List<HashMap<String, Object>>) groupData.get(groupClass);

                        if (itemsClassList != null) {

                            for (HashMap<String, Object> itemsClassData : itemsClassList) {
                                String itemClassAttr = itemsClassData.get("class").toString();
                                List<HashMap<String, Object>> itemList = (List<HashMap<String, Object>>) itemsClassData.get("items");

                                if (itemClassAttr.equals("네트워크 분리 운영여부")) {
                                    if (itemList != null) {
                                        for (HashMap<String, Object> itemData : itemList) {
                                            Row dataRow = securitySheet.createRow(security2RowP1++);
                                            dataRow.createCell(1).setCellValue((String) itemData.get("filename"));
                                            dataRow.getCell(1).setCellStyle(headerStyle);
                                            dataRow.createCell(2).setCellValue(itemClassAttr);
                                            dataRow.getCell(2).setCellStyle(thinCellStyle);
                                            dataRow.createCell(3).setCellValue((String) itemData.get("t3cell4"));
                                            dataRow.getCell(3).setCellStyle(thinCellStyle);
                                            dataRow.createCell(4).setCellValue((String) itemData.get("score"));
                                            dataRow.getCell(4).setCellStyle(thinCellStyle);
                                            dataRow.createCell(5).setCellValue((String) itemData.get("ranking"));
                                            dataRow.getCell(5).setCellStyle(thinCellStyle);
                                            // Add more cells as needed
                                        }
                                    }
                                } else if (itemClassAttr.equals("방화벽 여부")) {
                                    if (itemList != null) {
                                        for (HashMap<String, Object> itemData : itemList) {
                                            Row dataRow = securitySheet.createRow(security2RowP2++);
                                            dataRow.createCell(1).setCellValue((String) itemData.get("filename"));
                                            dataRow.getCell(1).setCellStyle(headerStyle);
                                            dataRow.createCell(2).setCellValue(itemClassAttr);
                                            dataRow.getCell(2).setCellStyle(thinCellStyle);
                                            dataRow.createCell(3).setCellValue((String) itemData.get("t3cell4"));
                                            dataRow.getCell(3).setCellStyle(thinCellStyle);
                                            dataRow.createCell(4).setCellValue((String) itemData.get("score"));
                                            dataRow.getCell(4).setCellStyle(thinCellStyle);
                                            dataRow.createCell(5).setCellValue((String) itemData.get("ranking"));
                                            dataRow.getCell(5).setCellStyle(thinCellStyle);
                                            // Add more cells as needed
                                        }
                                    }
                                } else if (itemClassAttr.equals("시스템 보안관리자 별도 운영여부")) {
                                    if (itemList != null) {
                                        for (HashMap<String, Object> itemData : itemList) {
                                            Row dataRow = securitySheet.createRow(security2RowP3++);
                                            dataRow.createCell(1).setCellValue((String) itemData.get("filename"));
                                            dataRow.getCell(1).setCellStyle(headerStyle);
                                            dataRow.createCell(2).setCellValue(itemClassAttr);
                                            dataRow.getCell(2).setCellStyle(thinCellStyle);
                                            dataRow.createCell(3).setCellValue((String) itemData.get("t3cell4"));
                                            dataRow.getCell(3).setCellStyle(thinCellStyle);
                                            dataRow.createCell(4).setCellValue((String) itemData.get("score"));
                                            dataRow.getCell(4).setCellStyle(thinCellStyle);
                                            dataRow.createCell(5).setCellValue((String) itemData.get("ranking"));
                                            dataRow.getCell(5).setCellStyle(thinCellStyle);
                                            // Add more cells as needed
                                        }
                                    }
                                }
                            }
                        }
                    }  else if (groupClass.equals("보안 교육 및 관리")) {
                        List<HashMap<String, Object>> itemsClassList = (List<HashMap<String, Object>>) groupData.get(groupClass);

                        if (itemsClassList != null) {

                            for (HashMap<String, Object> itemsClassData : itemsClassList) {
                                String itemClassAttr = itemsClassData.get("class").toString();
                                List<HashMap<String, Object>> itemList = (List<HashMap<String, Object>>) itemsClassData.get("items");

                                if (itemClassAttr.equals("보안 교육 유무")) {
                                    if (itemList != null) {
                                        for (HashMap<String, Object> itemData : itemList) {
                                            Row dataRow = securitySheet.createRow(security3RowP1++);
                                            dataRow.createCell(1).setCellValue((String) itemData.get("filename"));
                                            dataRow.getCell(1).setCellStyle(headerStyle);
                                            dataRow.createCell(2).setCellValue(itemClassAttr);
                                            dataRow.getCell(2).setCellStyle(thinCellStyle);
                                            dataRow.createCell(3).setCellValue((String) itemData.get("t3cell4"));
                                            dataRow.getCell(3).setCellStyle(thinCellStyle);
                                            dataRow.createCell(4).setCellValue((String) itemData.get("score"));
                                            dataRow.getCell(4).setCellStyle(thinCellStyle);
                                            dataRow.createCell(5).setCellValue((String) itemData.get("ranking"));
                                            dataRow.getCell(5).setCellStyle(thinCellStyle);
                                            // Add more cells as needed
                                        }
                                    }
                                } else if (itemClassAttr.equals("개인 저장매체 관리 방안여부")) {
                                    if (itemList != null) {
                                        for (HashMap<String, Object> itemData : itemList) {
                                            Row dataRow = securitySheet.createRow(security3RowP2++);
                                            dataRow.createCell(1).setCellValue((String) itemData.get("filename"));
                                            dataRow.getCell(1).setCellStyle(headerStyle);
                                            dataRow.createCell(2).setCellValue(itemClassAttr);
                                            dataRow.getCell(2).setCellStyle(thinCellStyle);
                                            dataRow.createCell(3).setCellValue((String) itemData.get("t3cell4"));
                                            dataRow.getCell(3).setCellStyle(thinCellStyle);
                                            dataRow.createCell(4).setCellValue((String) itemData.get("score"));
                                            dataRow.getCell(4).setCellStyle(thinCellStyle);
                                            dataRow.createCell(5).setCellValue((String) itemData.get("ranking"));
                                            dataRow.getCell(5).setCellStyle(thinCellStyle);
                                            // Add more cells as needed
                                        }
                                    }
                                } else if (itemClassAttr.equals("입출문 시 보안절차 여부")) {
                                    if (itemList != null) {
                                        for (HashMap<String, Object> itemData : itemList) {
                                            Row dataRow = securitySheet.createRow(security3RowP3++);
                                            dataRow.createCell(1).setCellValue((String) itemData.get("filename"));
                                            dataRow.getCell(1).setCellStyle(headerStyle);
                                            dataRow.createCell(2).setCellValue(itemClassAttr);
                                            dataRow.getCell(2).setCellStyle(thinCellStyle);
                                            dataRow.createCell(3).setCellValue((String) itemData.get("t3cell4"));
                                            dataRow.getCell(3).setCellStyle(thinCellStyle);
                                            dataRow.createCell(4).setCellValue((String) itemData.get("score"));
                                            dataRow.getCell(4).setCellStyle(thinCellStyle);
                                            dataRow.createCell(5).setCellValue((String) itemData.get("ranking"));
                                            dataRow.getCell(5).setCellStyle(thinCellStyle);
                                            // Add more cells as needed
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } else if (className.equals("total")) {
                List<HashMap<String, Object>> classDataList = entry.getValue();

                for (HashMap<String, Object> groupData : classDataList) {
                    if (groupData != null) {
                        Row dataRow = totalSheet.createRow(totalRowP++);
                        dataRow.createCell(1).setCellValue((String) groupData.get("filename"));
                        dataRow.getCell(1).setCellStyle(headerStyle);
                        dataRow.createCell(2).setCellValue((String) groupData.get("total"));
                        dataRow.getCell(2).setCellStyle(thinCellStyle);
                        dataRow.createCell(3).setCellValue((String) groupData.get("ranking"));
                        dataRow.getCell(3).setCellStyle(thinCellStyle);
                    }
                }
            } else if (className.equals("competitive_price")) {
                List<HashMap<String, Object>> classDataList = entry.getValue();

                for (HashMap<String, Object> groupData : classDataList) {
                    if (groupData != null) {
                        Row dataRow = biddingSheet.createRow(rowNum++);
                        dataRow.createCell(1).setCellValue((String) groupData.get("filename"));
                        dataRow.getCell(1).setCellStyle(headerStyle);
                        dataRow.createCell(2).setCellValue((String) groupData.get("t1cell2"));
                        dataRow.getCell(2).setCellStyle(thinCellStyle);
                        dataRow.createCell(3).setCellValue((String) groupData.get("t1cell3"));
                        dataRow.getCell(3).setCellStyle(thinCellStyle);
                        dataRow.createCell(4).setCellValue((String) groupData.get("result"));
                        dataRow.getCell(4).setCellStyle(thinCellStyle);
                        dataRow.createCell(5).setCellValue((String) groupData.get("ranking"));
                        dataRow.getCell(5).setCellStyle(thinCellStyle);
                    }
                }
            } else if (className.equals("satisfy")) {
                List<HashMap<String, Object>> classDataList = entry.getValue();
                int satisfy_CategoryIDP2 = 9;
                int satisfy_CategoryP2 = 9;
                boolean idWritten = false;
                boolean uniqueT6Cell1Written = false;

                for (HashMap<String, Object> groupData : classDataList) {
                    if (groupData != null) {
                        Row dataRow = satisfySheet.createRow(satisfyRowP++);
                        dataRow.createCell(1).setCellValue((String) groupData.get("filename"));
                        dataRow.getCell(1).setCellStyle(headerStyle);
                        dataRow.createCell(2).setCellValue((String) groupData.get("sum"));
                        dataRow.getCell(2).setCellStyle(thinCellStyle);
                        dataRow.createCell(3).setCellValue((String) groupData.get("score"));
                        dataRow.getCell(3).setCellStyle(thinCellStyle);
                        dataRow.createCell(4).setCellValue((String) groupData.get("ranking"));
                        dataRow.getCell(4).setCellStyle(thinCellStyle);
                        // Include uniqueT6Cell1 in dataRow
                        String uniqueT6Cell1 = (String) groupData.get("uniqueT6Cell1");
                        String id = (String) groupData.get("id");

                        //id' 정보가 아직 작성되지 않았고('!idWritten'), 'id' 정보가 null이 아니며('id != null'), 'id' 정보가 빈 문자열이 아닐 때('!id.isEmpty()') 실행
                        if (!idWritten && id != null && !id.isEmpty()) {
                            String[] idArray = id.split(", ");
                            for (String value : idArray) {
                                Row dataRow1 = satisfySheet.getRow(satisfy_CategoryIDP2++);
                                if(dataRow1 == null) {
                                    dataRow1 = satisfySheet.createRow(satisfy_CategoryIDP2 - 1);
                                }
                                dataRow1.createCell(1).setCellValue(value);
                                dataRow1.getCell(1).setCellStyle(headerStyle);



                            }
                            idWritten = true;
                        }
                        if (!uniqueT6Cell1Written && uniqueT6Cell1 != null && !uniqueT6Cell1.isEmpty()) {
                            String[] uniqueT6Cell1Array = uniqueT6Cell1.split(": ");
                            for (String value : uniqueT6Cell1Array) {
                                Row dataRow2 = satisfySheet.getRow(satisfy_CategoryP2);
                                if(dataRow2 == null) {
                                    dataRow2 = satisfySheet.createRow(satisfy_CategoryP2);
                                }
                                CellRangeAddress satisfy3Region = new CellRangeAddress(satisfy_CategoryP2, satisfy_CategoryP2, 2, 4);
                                satisfySheet.addMergedRegion(satisfy3Region);
                                setRegionBorder(BorderStyle.THIN, satisfy3Region, satisfySheet, workbook);

                                dataRow2.createCell(2).setCellValue(value);
                                dataRow2.getCell(2).setCellStyle(thinCellStyle);
                                satisfy_CategoryP2++;
                            }
                            uniqueT6Cell1Written = true;
                        }
                    }
                }
            } else if (className.equals("automation")) {
                List<HashMap<String, Object>> classDataList = entry.getValue();

                for (HashMap<String, Object> groupData : classDataList) {
                    if (groupData != null) {
                        if (groupData.get("itemsClass").equals("現 보유중인 자동화툴/프로그램 개수")) {
                            Row dataRow = automationSheet.createRow(automationRowP++);
                            dataRow.createCell(1).setCellValue((String) groupData.get("filename"));
                            dataRow.getCell(1).setCellStyle(headerStyle);
                            dataRow.createCell(2).setCellValue((String) groupData.get("t2cell3"));
                            dataRow.getCell(2).setCellStyle(thinCellStyle);
                            dataRow.createCell(3).setCellValue((String) groupData.get("t2cell4"));
                            dataRow.getCell(3).setCellStyle(thinCellStyle);
                            dataRow.createCell(4).setCellValue((String) groupData.get("score"));
                            dataRow.getCell(4).setCellStyle(thinCellStyle);
                            dataRow.createCell(5).setCellValue((String) groupData.get("t2cell5"));
                            dataRow.getCell(5).setCellStyle(thinCellStyle);
                            dataRow.createCell(6).setCellValue((String) groupData.get("ranking"));
                            dataRow.getCell(6).setCellStyle(thinCellStyle);
                        } else if (groupData.get("itemsClass").equals("직전 과제 대비 자동화 툴/프로그램 추가 개수")) {
                            Row dataRow = automationSheet.createRow(automationRowP2++);
                            dataRow.createCell(1).setCellValue((String) groupData.get("filename"));
                            dataRow.getCell(1).setCellStyle(headerStyle);
                            dataRow.createCell(2).setCellValue((String) groupData.get("t2cell3"));
                            dataRow.getCell(2).setCellStyle(thinCellStyle);
                            dataRow.createCell(3).setCellValue((String) groupData.get("t2cell4"));
                            dataRow.getCell(3).setCellStyle(thinCellStyle);
                            dataRow.createCell(4).setCellValue((String) groupData.get("score"));
                            dataRow.getCell(4).setCellStyle(thinCellStyle);
                            dataRow.createCell(5).setCellValue((String) groupData.get("t2cell5"));
                            dataRow.getCell(5).setCellStyle(thinCellStyle);
                            dataRow.createCell(6).setCellValue((String) groupData.get("ranking"));
                            dataRow.getCell(6).setCellStyle(thinCellStyle);
                        }
                    }
                }
            } else if (className.equals("quality")) {
                List<HashMap<String, Object>> classDataList = entry.getValue();

                for (HashMap<String, Object> groupData : classDataList) {

                    if (groupData != null) {
                        if (groupData.get("itemsClass").equals("직전과제 오류건 / 연간 진행 종수")) {
                            Row dataRow = qualitySheet.createRow(qualityRowP++);
                            dataRow.createCell(1).setCellValue((String) groupData.get("filename"));
                            dataRow.getCell(1).setCellStyle(headerStyle);
                            dataRow.createCell(2).setCellValue((String) groupData.get("t4cell3"));
                            dataRow.getCell(2).setCellStyle(thinCellStyle);
                            dataRow.createCell(3).setCellValue((String) groupData.get("t4cell4"));
                            dataRow.getCell(3).setCellStyle(thinCellStyle);
                            dataRow.createCell(4).setCellValue((String) groupData.get("score"));
                            dataRow.getCell(4).setCellStyle(thinCellStyle);
                            dataRow.createCell(5).setCellValue((String) groupData.get("t4cell5"));
                            dataRow.getCell(5).setCellStyle(thinCellStyle);
                            dataRow.createCell(6).setCellValue((String) groupData.get("ranking"));
                            dataRow.getCell(6).setCellStyle(thinCellStyle);
                        } else if (groupData.get("itemsClass").equals("S급 오류 개수")) {
                            Row dataRow = qualitySheet.createRow(qualityRowP2++);
                            dataRow.createCell(1).setCellValue((String) groupData.get("filename"));
                            dataRow.getCell(1).setCellStyle(headerStyle);
                            dataRow.createCell(2).setCellValue((String) groupData.get("t4cell3"));
                            dataRow.getCell(2).setCellStyle(thinCellStyle);
                            dataRow.createCell(3).setCellValue((String) groupData.get("t4cell4"));
                            dataRow.getCell(3).setCellStyle(thinCellStyle);
                            dataRow.createCell(4).setCellValue((String) groupData.get("score"));
                            dataRow.getCell(4).setCellStyle(thinCellStyle);
                            dataRow.createCell(5).setCellValue((String) groupData.get("t4cell5"));
                            dataRow.getCell(5).setCellStyle(thinCellStyle);
                            dataRow.createCell(6).setCellValue((String) groupData.get("ranking"));
                            dataRow.getCell(6).setCellStyle(thinCellStyle);
                        }
                    }
                }
            } else if (className.equals("delivery_compliance")) {
                List<HashMap<String, Object>> classDataList = entry.getValue();

                for (HashMap<String, Object> groupData : classDataList) {
                    if (groupData != null) {
                        Row dataRow = delivery_complianceSheet.createRow(delivery_complianceSheetRowP++);

                        dataRow.createCell(1).setCellValue((String) groupData.get("filename"));
                        dataRow.getCell(1).setCellStyle(headerStyle);
                        dataRow.createCell(2).setCellValue((String) groupData.get("t5cell3"));
                        dataRow.getCell(2).setCellStyle(thinCellStyle);
                        dataRow.createCell(3).setCellValue((String) groupData.get("t5cell4"));
                        dataRow.getCell(3).setCellStyle(thinCellStyle);
                        dataRow.createCell(4).setCellValue((String) groupData.get("score"));
                        dataRow.getCell(4).setCellStyle(thinCellStyle);
                        dataRow.createCell(5).setCellValue((String) groupData.get("t5cell5"));
                        dataRow.getCell(5).setCellStyle(thinCellStyle);
                        dataRow.createCell(6).setCellValue((String) groupData.get("ranking"));
                        dataRow.getCell(6).setCellStyle(thinCellStyle);

                    }
                }

            }
            else {
            }
        }

        setWidthAsPerCellContent(totalSheet);
        setWidthAsPerCellContent(biddingSheet);
        setWidthAsPerCellContent(satisfySheet);
        setWidthAsPerCellContent(automationSheet);
        setWidthAsPerCellContent(qualitySheet);
        setWidthAsPerCellContent(delivery_complianceSheet);
        setWidthAsPerCellContent(securitySheet);

        try (FileOutputStream outputStream = new FileOutputStream(filePath)) {
            workbook.write(outputStream);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void setWidthAsPerCellContent(Sheet sheet) {
        for (int rowIndex = 0; rowIndex <= sheet.getLastRowNum(); rowIndex++) {
            Row row = sheet.getRow(rowIndex);
            if (row != null) {
                for (int colIndex = 0; colIndex < row.getLastCellNum(); colIndex++) {
                    Cell cell = row.getCell(colIndex);
                    if (cell != null) {
                        String cellValue = "";
                        switch (cell.getCellType()) {
                            case STRING:
                                cellValue = cell.getStringCellValue();
                                break;
                            case NUMERIC:
                                cellValue = String.valueOf(cell.getNumericCellValue());
                                break;
                            default:
                                cellValue = ""; // 기본값 설정 혹은 예외 처리
                        }

                        int cellLength = (int) (cellValue.length() + cellValue.chars().filter(Character::isLetter).count());
                        int cellWidth = sheet.getColumnWidth(colIndex); // 기본 셀 폭
                        int preferredWidth = (cellLength + 2) * 256;

                        if (preferredWidth > cellWidth) {
                            sheet.setColumnWidth(colIndex, preferredWidth); // 셀 폭을 설정한 폭으로 변경
                        }
                    }
                }
            }
        }
    }

    private static void setRegionBorder(BorderStyle  border, CellRangeAddress region, Sheet sheet, Workbook wb) {
        RegionUtil.setBorderBottom(border, region, sheet);
        RegionUtil.setBorderTop(border, region, sheet);
        RegionUtil.setBorderLeft(border, region, sheet);
        RegionUtil.setBorderRight(border, region, sheet);
    }
    private static CellStyle createHeaderStyle(Workbook workbook) {
        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setAlignment(HorizontalAlignment.CENTER);
        headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        headerStyle.setFillForegroundColor(IndexedColors.LEMON_CHIFFON.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

        headerStyle.setBorderTop(BorderStyle.THIN);
        headerStyle.setBorderBottom(BorderStyle.THIN);
        headerStyle.setBorderLeft(BorderStyle.THIN);
        headerStyle.setBorderRight(BorderStyle.THIN);
        return headerStyle;
    }

    private static CellStyle createCellStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);

        style.setBorderTop(BorderStyle.THIN);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        return style;
    }

    public static void createExcelSatisfactionTemplate(String filePath) {
        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet("협렵사 만족도 조사");

        String[] headers = {"전혀 그렇지 않다", "그렇지 않다", "보통이다", "그렇다", "매우 그렇다"};
        String[] questions = {
                "1. 일정 관리가 잘 되었는가?",
                "2. 모델 진행상황이 잘 공유되었는가?",
                "3. 기능에 대해 정확히 이해하고 문장을 작성하려고 하였는가?",
                "4. 결과물이 만족스러웠는가?",
                "5. 모델 관련 이력 관리를 잘 하였는가?",
                "6. 삼성에서 요청한 사항에서 발생할 수 있는 문제 등에 대한 의견이나 제안등을 잘 하였는가?",
                "7. 직원들의 마인드와 태도가 만족스러웠는가?",
                "8. 시료 파손, 분실 없이 잘 관리하였는가?",
                "9. 오류 발생 시 문제해결과 재발방지를 위해 적극적으로 대응하였는가?",
                "10. 업무 효율을 높이기 위한 새로운 시도나 개선사항을 적극적으로 제안하였는가?"
        };

        // Create cell style for border and alignment
        CellStyle style = workbook.createCellStyle();
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);

        // Cell style for headers
        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.cloneStyleFrom(style);
        headerStyle.setFillForegroundColor(IndexedColors.LEMON_CHIFFON.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

        CellStyle headerYesNoStyle = workbook.createCellStyle();
        headerYesNoStyle.setBorderBottom(BorderStyle.MEDIUM);  // Set bottom border
        headerYesNoStyle.setBorderTop(BorderStyle.THIN);     // Set top border
        headerYesNoStyle.setBorderLeft(BorderStyle.MEDIUM);    // Set left border
        headerYesNoStyle.setBorderRight(BorderStyle.MEDIUM);   // Set right border

        // Cell style for "항목"
        CellStyle itemStyle = workbook.createCellStyle();
        itemStyle.setBorderBottom(BorderStyle.THIN);  // Set bottom border
        itemStyle.setBorderTop(BorderStyle.THIN);     // Set top border
        itemStyle.setBorderLeft(BorderStyle.THIN);    // Set left border
        itemStyle.setBorderRight(BorderStyle.THIN);   // Set right border
        itemStyle.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());
        itemStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        itemStyle.setAlignment(HorizontalAlignment.CENTER);
        itemStyle.setVerticalAlignment(VerticalAlignment.CENTER);

        CellStyle footerStyle = workbook.createCellStyle();
        footerStyle.setBorderBottom(BorderStyle.MEDIUM);
        footerStyle.setBorderTop(BorderStyle.MEDIUM);
        footerStyle.setBorderLeft(BorderStyle.MEDIUM);
        footerStyle.setBorderRight(BorderStyle.MEDIUM);

        CellStyle titleStyle = workbook.createCellStyle();
        titleStyle.setAlignment(HorizontalAlignment.CENTER);
        titleStyle.setVerticalAlignment(VerticalAlignment.CENTER);

        Font titleFont = workbook.createFont();
        titleFont.setColor(IndexedColors.BLUE.getIndex());
        titleFont.setFontHeightInPoints((short) 20);
        titleFont.setBold(true);
        titleFont.setFontName("맑은 고딕");

        titleStyle.setFont(titleFont);

        XSSFRow titleRow = sheet.createRow(1);
        Cell titleCell = titleRow.createCell(1);
        titleCell.setCellValue("협력사 만족도 조사");
        titleCell.setCellStyle(titleStyle);
        sheet.addMergedRegion(new CellRangeAddress(1, 2, 1, 6));

        XSSFRow itemRow = sheet.createRow(4);
        Cell itemCell = itemRow.createCell(1);
        itemCell.setCellValue("항목");
        itemCell.setCellStyle(itemStyle);

        XSSFRow itemRow2 = sheet.createRow(5);
        Cell itemCell2 = itemRow2.createCell(1);
        itemCell2.setCellStyle(itemStyle);

        CellRangeAddress mergedRegion = new CellRangeAddress(4, 5, 1, 1);
        sheet.addMergedRegion(mergedRegion);


        Cell headerEmptyCell = itemRow.createCell(2);
        headerEmptyCell.setCellValue("");
        headerEmptyCell.setCellStyle(headerStyle);
        sheet.addMergedRegion(new CellRangeAddress(4, 4, 2, 6));

        XSSFRow footerRow = sheet.createRow(16);
        Cell footerCell = footerRow.createCell(1);
        footerCell.setCellValue("■ 기타 건의 사항");
        footerCell.setCellStyle(footerStyle);

        Cell footerEmptyCell = footerRow.createCell(2);
        footerEmptyCell.setCellValue("");
        footerEmptyCell.setCellStyle(footerStyle);

        CellRangeAddress footerEmptyMerged = new CellRangeAddress(16, 16, 2, 6);
        sheet.addMergedRegion(footerEmptyMerged);
        RegionUtil.setBorderTop(BorderStyle.MEDIUM, footerEmptyMerged, sheet);
        RegionUtil.setBorderBottom(BorderStyle.MEDIUM, footerEmptyMerged, sheet);
        RegionUtil.setBorderLeft(BorderStyle.MEDIUM, footerEmptyMerged, sheet);
        RegionUtil.setBorderRight(BorderStyle.MEDIUM, footerEmptyMerged, sheet);
        RegionUtil.setBorderBottom(BorderStyle.THIN, new CellRangeAddress(4, 4, 2, 6), sheet);
        RegionUtil.setBorderTop(BorderStyle.MEDIUM, new CellRangeAddress(4, 4, 2, 6), sheet);
        RegionUtil.setBorderLeft(BorderStyle.MEDIUM, new CellRangeAddress(4, 4, 2, 6), sheet);
        RegionUtil.setBorderRight(BorderStyle.MEDIUM, new CellRangeAddress(4, 4, 2, 6), sheet);

        XSSFRow headerRow = sheet.createRow(5);
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i + 2);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerYesNoStyle); // Set cell style for headers
        }

        for (int i = 0; i < questions.length; i++) {
            XSSFRow questionRow = sheet.createRow(i + 6);
            Cell cell = questionRow.createCell(1);
            cell.setCellValue(questions[i]);
            cell.setCellStyle(style);

            // Create empty cells with border
            for (int j = 2; j <= 6; j++) {
                Cell emptyCell = questionRow.createCell(j);
                emptyCell.setCellStyle(style);
            }
        }

        try (FileOutputStream fileOut = new FileOutputStream(filePath)) {
            workbook.write(fileOut);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}