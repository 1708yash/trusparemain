class YPricingCalculator{
  /// calculate price and tax and shipping
  static double calculateTotalPrice(double productPrice,String location){
    double taxRate = getTaxRateForLocation(location);
    double taxAmount = productPrice * taxRate;

    double shippingCost = getShippingCost(location);

    double totalPrice = productPrice+taxAmount+ shippingCost;
    return totalPrice;
  }

  // calculate shipping cost

static String calculateShippingCost(double productPrice,String location){
    double shippingCost = getShippingCost(location);
    return shippingCost.toStringAsFixed(2);
}

// calculate tax
static String calculateTax(double productPrice,String location){
    double taxRate = getTaxRateForLocation(location);
    double taxAmount = productPrice * taxRate;
    return taxAmount.toStringAsFixed(2);
}

static double getTaxRateForLocation(String location){
    // need to add as required taking .10 as the hardcode value for now, rest will be placed using if else function with time
  return 0.10;
}

static double getShippingCost(String location){
    // will also be added on the basis of location later with if else statements
  return 5.1;  // taking a hardcode value
}
}