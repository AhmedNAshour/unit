class Compound {
  final String logoURL;
  final String agentName;
  final String uid;
  final String locationLevel2;
  final String locationLevel1;
  final String governateAr;
  final String districtAr;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final List propertyTypes;
  final List facilities;
  final String areasAndUnits;
  final bool offer;
  final List images;
  final String paymentPlan;
  final String paymentPlanAr;
  final int meterPrice;
  final int startingPrice;
  final double latitude;
  final double longitude;
  final String status;
  final String deliveryDate;
  final String finishingType;
  final bool highlighted;
  final DateTime dateTime;

  Compound({
    this.descriptionAr,
    this.offer,
    this.paymentPlanAr,
    this.nameAr,
    this.governateAr,
    this.districtAr,
    this.dateTime,
    this.facilities,
    this.logoURL,
    this.startingPrice,
    this.finishingType,
    this.highlighted,
    this.name,
    this.propertyTypes,
    this.areasAndUnits,
    this.paymentPlan,
    this.agentName,
    this.meterPrice,
    this.deliveryDate,
    this.status,
    this.uid,
    this.locationLevel2,
    this.locationLevel1,
    this.description,
    this.images,
    this.latitude,
    this.longitude,
  });
}
