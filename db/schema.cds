namespace demo;
 
entity Vendors {
  key ID     : Integer;
      name   : String(100);
      city   : String(50);
      active : Boolean;
}
 
entity Products {
  key ID       : Integer;
      name     : String(100);
      price    : Decimal(9,2);
      vendorID : Integer;
}
 
entity Orders {
  key ID        : Integer;
      productID : Integer;
      quantity  : Integer;
}