class FakeData {
  static String customerData = """ {"customers" : [
  {
    "name": "John",
    "surname": "Doe",
    "tc_no": "12345678901",
    "tax_no": "9876543210",
    "tel_no": "+1-555-1234",
    "address": "123 Elm St, Springfield",
    "debit": 250.5
  },
  {
    "name": "Jane",
    "surname": "Smith",
    "tc_no": "23456789012",
    "tax_no": "8765432109",
    "tel_no": "+1-555-5678",
    "address": "456 Oak Ave, Springfield",
    "debit": 120.0
  },
  {
    "name": "Michael",
    "surname": "Johnson",
    "tc_no": "34567890123",
    "tax_no": "7654321098",
    "tel_no": "+1-555-8765",
    "address": "789 Pine Rd, Lincoln",
    "debit": 310.2
  },
  {
    "name": "Emily",
    "surname": "Williams",
    "tc_no": "45678901234",
    "tax_no": "6543210987",
    "tel_no": "+1-555-4321",
    "address": "101 Maple St, Lincoln",
    "debit": 415.8
  },
  {
    "name": "Daniel",
    "surname": "Brown",
    "tc_no": "56789012345",
    "tax_no": "5432109876",
    "tel_no": "+1-555-1357",
    "address": "202 Cedar Blvd, Oakville",
    "debit": 150.3
  },
  {
    "name": "Olivia",
    "surname": "Davis",
    "tc_no": "67890123456",
    "tax_no": "4321098765",
    "tel_no": "+1-555-2468",
    "address": "303 Birch Dr, Oakville",
    "debit": 275.9
  },
  {
    "name": "James",
    "surname": "Miller",
    "tc_no": "78901234567",
    "tax_no": "3210987654",
    "tel_no": "+1-555-8642",
    "address": "404 Walnut St, Rivertown",
    "debit": 199.4
  },
  {
    "name": "Sophia",
    "surname": "Wilson",
    "tc_no": "89012345678",
    "tax_no": "2109876543",
    "tel_no": "+1-555-7531",
    "address": "505 Chestnut Ln, Rivertown",
    "debit": 320.8
  },
  {
    "name": "Benjamin",
    "surname": "Moore",
    "tc_no": "90123456789",
    "tax_no": "1098765432",
    "tel_no": "+1-555-9999",
    "address": "606 Pinehill Rd, Lakeview",
    "debit": 540.6
  },
  {
    "name": "Amelia",
    "surname": "Taylor",
    "tc_no": "12334567890",
    "tax_no": "9987654321",
    "tel_no": "+1-555-9876",
    "address": "707 Rose St, Lakeview",
    "debit": 430.7
  },
  {
    "name": "William",
    "surname": "Anderson",
    "tc_no": "23445678901",
    "tax_no": "8876543210",
    "tel_no": "+1-555-6543",
    "address": "808 Tulip Ave, Greenfield",
    "debit": 215.4
  },
  {
    "name": "Charlotte",
    "surname": "Thomas",
    "tc_no": "34556789012",
    "tax_no": "7765432109",
    "tel_no": "+1-555-3210",
    "address": "909 Lily Ln, Greenfield",
    "debit": 510.2
  },
  {
    "name": "Henry",
    "surname": "Jackson",
    "tc_no": "45667890123",
    "tax_no": "6654321098",
    "tel_no": "+1-555-1235",
    "address": "1010 Daisy St, Clearwater",
    "debit": 119.8
  },
  {
    "name": "Evelyn",
    "surname": "White",
    "tc_no": "56778901234",
    "tax_no": "5543210987",
    "tel_no": "+1-555-5679",
    "address": "1111 Sunflower Ave, Clearwater",
    "debit": 670.9
  },
  {
    "name": "Alexander",
    "surname": "Harris",
    "tc_no": "67889012345",
    "tax_no": "4432109876",
    "tel_no": "+1-555-9753",
    "address": "1212 Orchid Blvd, Seaview",
    "debit": 189.6
  },
  {
    "name": "Mia",
    "surname": "Martin",
    "tc_no": "78990123456",
    "tax_no": "3321098765",
    "tel_no": "+1-555-8640",
    "address": "1313 Jasmine Rd, Seaview",
    "debit": 212.7
  },
  {
    "name": "Lucas",
    "surname": "Garcia",
    "tc_no": "89001234567",
    "tax_no": "2210987654",
    "tel_no": "+1-555-4444",
    "address": "1414 Palm St, Hilltop",
    "debit": 478.3
  },
  {
    "name": "Zoe",
    "surname": "Martinez",
    "tc_no": "90112345678",
    "tax_no": "1109876543",
    "tel_no": "+1-555-3333",
    "address": "1515 Mango Ave, Hilltop",
    "debit": 635.2
  },
  {
    "name": "Samuel",
    "surname": "Rodriguez",
    "tc_no": "12323456789",
    "tax_no": "9987654321",
    "tel_no": "+1-555-1111",
    "address": "1616 Peach Blvd, Sunset",
    "debit": 299.1
  },
  {
    "name": "Grace",
    "surname": "Lee",
    "tc_no": "23434567890",
    "tax_no": "8876543210",
    "tel_no": "+1-555-8888",
    "address": "1717 Mango St, Sunset",
    "debit": 125.4
  }
]
} """;

  static String workOrdersData = """ {"work_orders" : [
  {
    "customer_name": "Ahmet Yılmaz",
    "repairman_name": "Mehmet Demir",
    "repairman_id": "rmp-10293",
    "customer_tc_no": "12345678901",
    "tel_no": "+90 532 123 4567",
    "plate_no": "34 ABC 123",
    "work_state": {
      "state": "working",
      "time": 1745073000000
    }
  },
  {
    "customer_name": "Zeynep Kaya",
    "repairman_name": "Ali Vural",
    "repairman_id": "rmp-20876",
    "customer_tc_no": "23456789012",
    "tel_no": "+90 533 987 6543",
    "plate_no": "06 DEF 456",
    "work_state": {
      "state": "registered",
      "time": 1745053200000
    }
  },
  {
    "customer_name": "Mert Aksoy",
    "repairman_name": "Cem Yılmaz",
    "repairman_id": "rmp-34567",
    "customer_tc_no": "34567890123",
    "tel_no": "+90 534 654 3210",
    "plate_no": "35 GHI 789",
    "work_state": {
      "state": "done",
      "time": 1744988700000
    }
  },
  {
    "customer_name": "Elif Demirtaş",
    "repairman_name": "Hakan Öz",
    "repairman_id": "rmp-98234",
    "customer_tc_no": "45678901234",
    "tel_no": "+90 535 123 7890",
    "plate_no": "41 JKL 321",
    "work_state": {
      "state": "testing",
      "time": 1745061000000
    }
  },
  {
    "customer_name": "Burak Koç",
    "repairman_name": "Tuna Gürel",
    "repairman_id": "rmp-44512",
    "customer_tc_no": "56789012345",
    "tel_no": "+90 536 456 7890",
    "plate_no": "42 MNO 654",
    "work_state": {
      "state": "registered",
      "time": 1745082000000
    }
  },
  {
    "customer_name": "Sena Bayraktar",
    "repairman_name": "Ömer Faruk",
    "repairman_id": "rmp-67281",
    "customer_tc_no": "67890123456",
    "tel_no": "+90 537 321 4567",
    "plate_no": "01 PQR 987",
    "work_state": {
      "state": "working",
      "time": 1745094000000
    }
  },
  {
    "customer_name": "Emre Tunç",
    "repairman_name": "Barış Şahin",
    "repairman_id": "rmp-18364",
    "customer_tc_no": "78901234567",
    "tel_no": "+90 538 654 9870",
    "plate_no": "07 STU 111",
    "work_state": {
      "state": "done",
      "time": 1745000000000
    }
  },
  {
    "customer_name": "Nazlı Ay",
    "repairman_name": "Kerem Bulut",
    "repairman_id": "rmp-92034",
    "customer_tc_no": "89012345678",
    "tel_no": "+90 539 987 0000",
    "plate_no": "33 VWX 222",
    "work_state": {
      "state": "testing",
      "time": 1745033000000
    }
  },
  {
    "customer_name": "Umut Aydın",
    "repairman_name": "Salih İnce",
    "repairman_id": "rmp-83745",
    "customer_tc_no": "90123456789",
    "tel_no": "+90 530 222 3333",
    "plate_no": "27 YZA 333",
    "work_state": {
      "state": "working",
      "time": 1745078000000
    }
  },
  {
    "customer_name": "Gülşah Akın",
    "repairman_name": "Murat Polat",
    "repairman_id": "rmp-76541",
    "customer_tc_no": "11223344556",
    "tel_no": "+90 531 111 2222",
    "plate_no": "10 BCD 444",
    "work_state": {
      "state": "done",
      "time": 1744900000000
    }
  }
]
} """;
}
