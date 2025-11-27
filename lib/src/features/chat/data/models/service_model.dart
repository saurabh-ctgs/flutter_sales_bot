class SearchServiceModel {
  String? responseCode;
  String? message;
  Content? content;

  SearchServiceModel({this.responseCode, this.message, this.content});

  SearchServiceModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    content = json['content'] != null
        ? Content.fromJson(json['content'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_code'] = responseCode;
    data['message'] = message;
    if (content != null) {
      data['content'] = content!.toJson();
    }

    return data;
  }
}

class Content {
  double? initialMinPrice;
  double? initialMaxPrice;
  double? filteredMinPrice;
  double? filteredMaxPrice;
  ServiceContent? servicesContent;

  Content({this.initialMinPrice, this.initialMaxPrice, this.servicesContent});

  Content.fromJson(Map<String, dynamic> json) {
    initialMinPrice = double.tryParse(json['initial_min_price'].toString());
    initialMaxPrice = double.tryParse(json['initial_max_price'].toString());
    filteredMinPrice = double.tryParse(json['filter_min_price'].toString());
    filteredMaxPrice = double.tryParse(json['filter_max_price'].toString());
    servicesContent = json['services'] != null
        ? ServiceContent.fromJson(json['services'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['min_price'] = initialMinPrice;
    data['max_price'] = initialMaxPrice;
    if (servicesContent != null) {
      data['services'] = servicesContent!.toJson();
    }
    return data;
  }
}

class ServiceContent {
  int? currentPage;
  List<Service>? serviceList;
  int? from;
  int? lastPage;
  int? total;

  ServiceContent({
    this.currentPage,
    this.serviceList,
    this.from,
    this.lastPage,
    this.total,
  });

  ServiceContent.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      serviceList = <Service>[];
      json['data'].forEach((v) {
        serviceList!.add(Service.fromJson(v));
      });
    }
    from = json['from'];
    lastPage = json['last_page'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (serviceList != null) {
      data['data'] = serviceList!.map((v) => v.toJson()).toList();
    }
    data['from'] = from;
    data['last_page'] = lastPage;
    data['total'] = total;
    return data;
  }
}

class Service {
  String? id;
  String? name;
  String? shortDescription;
  String? description;
  String? coverImage;
  String? coverImageFullPath;
  String? thumbnail;
  String? thumbnailFullPath;
  String? categoryId;
  String? subCategoryId;
  double? tax;
  int? orderCount;
  int? isActive;
  int? isFavorite;
  int? ratingCount;
  double? avgRating;
  String? createdAt;
  String? updatedAt;
  ServiceCategory? category;
  VariationsAppFormat? variationsAppFormat;
  List<Variations>? variations;
  List<Faqs>? faqs;
  List<ServiceDiscount>? serviceDiscount;
  List<ServiceDiscount>? campaignDiscount;

  // List<Review>? review;

  Service({
    this.id,
    this.name,
    this.shortDescription,
    this.description,
    this.coverImage,
    this.coverImageFullPath,
    this.thumbnail,
    this.thumbnailFullPath,
    this.categoryId,
    this.subCategoryId,
    this.tax,
    this.orderCount,
    this.isActive,
    this.isFavorite,
    this.ratingCount,
    this.avgRating,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.variationsAppFormat,
    this.variations,
    this.faqs,
    this.serviceDiscount,
    this.campaignDiscount,
    // this.review,
  });

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortDescription = json['short_description'];
    description = json['description'];
    coverImage = json['cover_image'];
    coverImageFullPath = json['cover_image_full_path'];
    thumbnail = json['thumbnail'];
    thumbnailFullPath = json['thumbnail_full_path'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    tax = double.tryParse(json['tax'].toString());
    orderCount = json['order_count'];
    isActive = json['is_active'];
    isFavorite = json['is_favorite'];
    ratingCount = json['rating_count'];
    avgRating = json['avg_rating'].toDouble();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    variationsAppFormat = json['variations_app_format'] != null
        ? VariationsAppFormat.fromJson(json['variations_app_format'])
        : null;

    if (json['variations'] != null) {
      variations = <Variations>[];
      json['variations'].forEach((v) {
        variations!.add(Variations.fromJson(v));
      });
    }

    // if (json['reviews'] != null) {
    //   review = <Review>[];
    //   json['reviews'].forEach((v) {
    //     review!.add(Review.fromJson(v));
    //   });
    // }

    category = json['category'] != null
        ? ServiceCategory.fromJson(json['category'])
        : null;
    if (json['faqs'] != null) {
      faqs = <Faqs>[];
      json['faqs'].forEach((v) {
        faqs!.add(Faqs.fromJson(v));
      });
    }
    if (json['service_discount'] != null) {
      serviceDiscount = <ServiceDiscount>[];
      json['service_discount'].forEach((v) {
        serviceDiscount!.add(ServiceDiscount.fromJson(v));
      });
    }
    if (json['campaign_discount'] != null) {
      campaignDiscount = <ServiceDiscount>[];
      json['campaign_discount'].forEach((v) {
        campaignDiscount!.add(ServiceDiscount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['short_description'] = shortDescription;
    data['description'] = description;
    data['cover_image'] = coverImage;
    data['cover_image_full_path'] = coverImageFullPath;
    data['thumbnail'] = thumbnail;
    data['thumbnail_full_path'] = thumbnailFullPath;
    data['category_id'] = categoryId;
    data['sub_category_id'] = subCategoryId;
    data['tax'] = tax;
    data['order_count'] = orderCount;
    data['is_active'] = isActive;
    data['is_favorite'] = isFavorite;
    data['rating_count'] = ratingCount;
    data['avg_rating'] = avgRating;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (variationsAppFormat != null) {
      data['variations_app_format'] = variationsAppFormat!.toJson();
    }

    if (variations != null) {
      data['variations'] = variations!.map((v) => v.toJson()).toList();
    }
    // if (review != null) {
    //   data['reviews'] = review!.map((v) => v.toJson()).toList();
    // }

    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (faqs != null) {
      data['faqs'] = faqs!.map((v) => v.toJson()).toList();
    }
    if (serviceDiscount != null) {
      data['service_discount'] = serviceDiscount!
          .map((v) => v.toJson())
          .toList();
    }
    if (campaignDiscount != null) {
      data['campaign_discount'] = campaignDiscount!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class VariationsAppFormat {
  String? zoneId;
  double? defaultPrice;
  List<ZoneWiseVariations>? zoneWiseVariations;

  VariationsAppFormat({
    this.zoneId,
    this.defaultPrice,
    this.zoneWiseVariations,
  });

  VariationsAppFormat.fromJson(Map<String, dynamic> json) {
    zoneId = json['zone_id'];
    defaultPrice = json['default_price'].toDouble();
    if (json['zone_wise_variations'] != null) {
      zoneWiseVariations = <ZoneWiseVariations>[];
      json['zone_wise_variations'].forEach((v) {
        zoneWiseVariations!.add(ZoneWiseVariations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['zone_id'] = zoneId;
    data['default_price'] = defaultPrice;
    if (zoneWiseVariations != null) {
      data['zone_wise_variations'] = zoneWiseVariations!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class Variations {
  int? id;
  String? variant;
  String? variantKey;
  String? serviceId;
  String? zoneId;
  num? price;
  String? createdAt;
  String? updatedAt;

  // Zone? zone;

  Variations({
    this.id,
    this.variant,
    this.variantKey,
    this.serviceId,
    this.zoneId,
    this.price,
    this.createdAt,
    this.updatedAt,
    // this.zone
  });

  Variations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    variant = json['variant'];
    variantKey = json['variant_key'];
    serviceId = json['service_id'];
    zoneId = json['zone_id'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['variant'] = variant;
    data['variant_key'] = variantKey;
    data['service_id'] = serviceId;
    data['zone_id'] = zoneId;
    data['price'] = price;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ZoneWiseVariations {
  String? variantKey;
  String? variantName;
  num? price;

  ZoneWiseVariations({this.variantKey, this.variantName, this.price});

  ZoneWiseVariations.fromJson(Map<String, dynamic> json) {
    variantKey = json['variant_key'];
    variantName = json['variant_name'];
    price = json['price'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['variant_key'] = variantKey;
    data['variant_name'] = variantName;
    data['price'] = price;
    return data;
  }
}

class ServiceCategory {
  String? id;
  String? parentId;
  String? name;
  String? image;
  int? position;
  String? description;
  int? isActive;
  String? createdAt;
  String? updatedAt;

  List<ServiceDiscount>? categoryDiscount;
  List<ServiceDiscount>? campaignDiscount;

  ServiceCategory({
    this.id,
    this.parentId,
    this.name,
    this.image,
    this.position,
    this.description,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.categoryDiscount,
    this.campaignDiscount,
  });

  ServiceCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    name = json['name'];
    image = json['image'];
    position = json['position'];
    description = json['description'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    if (json['category_discount'] != null) {
      categoryDiscount = <ServiceDiscount>[];
      json['category_discount'].forEach((v) {
        categoryDiscount!.add(ServiceDiscount.fromJson(v));
      });
    }
    if (json['campaign_discount'] != null) {
      campaignDiscount = <ServiceDiscount>[];
      json['campaign_discount'].forEach((v) {
        campaignDiscount!.add(ServiceDiscount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    data['name'] = name;
    data['image'] = image;
    data['position'] = position;
    data['description'] = description;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;

    if (categoryDiscount != null) {
      data['category_discount'] = categoryDiscount!
          .map((v) => v.toJson())
          .toList();
    }
    if (campaignDiscount != null) {
      data['campaign_discount'] = campaignDiscount!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class Faqs {
  String? id;
  String? question;
  String? answer;
  String? serviceId;
  int? isActive;
  String? createdAt;
  String? updatedAt;

  Faqs({
    this.id,
    this.question,
    this.answer,
    this.serviceId,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  Faqs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
    serviceId = json['service_id'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['answer'] = answer;
    data['service_id'] = serviceId;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ServiceDiscount {
  int? id;
  String? discountId;
  String? discountType;
  String? typeWiseId;
  String? createdAt;
  String? updatedAt;
  Discount? discount;

  ServiceDiscount({
    this.id,
    this.discountId,
    this.discountType,
    this.typeWiseId,
    this.createdAt,
    this.updatedAt,
    this.discount,
  });

  ServiceDiscount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    discountId = json['discount_id'];
    discountType = json['discount_type'];
    typeWiseId = json['type_wise_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    discount = json['discount'] != null
        ? Discount.fromJson(json['discount'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['discount_id'] = discountId;
    data['discount_type'] = discountType;
    data['type_wise_id'] = typeWiseId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (discount != null) {
      data['discount'] = discount!.toJson();
    }
    return data;
  }
}

class Discount {
  String? id;
  String? discountTitle;
  String? discountType;
  double? discountAmount;
  String? discountAmountType;
  double? minPurchase;
  num? maxDiscountAmount;
  int? limitPerUser;
  String? promotionType;
  int? isActive;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;

  Discount({
    this.id,
    this.discountTitle,
    this.discountType,
    this.discountAmount,
    this.discountAmountType,
    this.minPurchase,
    this.maxDiscountAmount,
    this.limitPerUser,
    this.promotionType,
    this.isActive,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  Discount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    discountTitle = json['discount_title'];
    discountType = json['discount_type'];
    discountAmount = double.tryParse(json['discount_amount'].toString());
    discountAmountType = json['discount_amount_type'];
    minPurchase = double.tryParse(json['min_purchase'].toString());
    maxDiscountAmount = json['max_discount_amount'];
    limitPerUser = json['limit_per_user'];
    promotionType = json['promotion_type'];
    isActive = json['is_active'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['discount_title'] = discountTitle;
    data['discount_type'] = discountType;
    data['discount_amount'] = discountAmount;
    data['discount_amount_type'] = discountAmountType;
    data['min_purchase'] = minPurchase;
    data['max_discount_amount'] = maxDiscountAmount;
    data['limit_per_user'] = limitPerUser;
    data['promotion_type'] = promotionType;
    data['is_active'] = isActive;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ProductResponseModel {
  String? responseCode;
  String? message;
  List<ProductItemModel>? products;

  ProductResponseModel({this.responseCode, this.message, this.products});

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      responseCode: json['response_code'],
      message: json['message'],
      products: (json['data'] as List)
          .map((e) => ProductItemModel.fromJson(e))
          .toList(),
    );
  }
}

ProductResponseModel mapServiceJsonToProductResponse(
  Map<String, dynamic> json,
) {
  final ProductResponseModel result = ProductResponseModel(
    responseCode: json['response_code'],
    message: json['message'],
    products: [],
  );

  // Navigate: content → services → data
  final services = json['content']?['services']?['data'];
  if (services == null || services is! List) return result;

  for (final srv in services) {
    // ------- Title -------
    final title = srv['name'];

    // ------- Description -------
    final description = srv['short_description'] ?? srv['description'];

    // ------- Thumbnails -------
    final List<String> thumbnails =
        [
              srv['thumbnail_full_path'],
              srv['thumbnail'],
              srv['cover_image_full_path'],
              srv['cover_image'],
            ]
            .where((e) => e != null && e.toString().trim().isNotEmpty)
            .map((e) => e.toString())
            .toList();

    // ------- Price -------
    String price = '';

    try {
      // Priority: variations[0].price
      final variations = srv['variations'];
      if (variations is List && variations.isNotEmpty) {
        final vPrice = variations[0]['price'];
        if (vPrice != null) price = vPrice.toString();
      }

      // Fallback: variations_app_format.default_price
      if (price.isEmpty &&
          srv['variations_app_format']?['default_price'] != null) {
        price = srv['variations_app_format']['default_price'].toString();
      }

      // Fallback: zone_wise_variations[0].price
      final zoneVariations =
          srv['variations_app_format']?['zone_wise_variations'];
      if (price.isEmpty &&
          zoneVariations is List &&
          zoneVariations.isNotEmpty &&
          zoneVariations[0]['price'] != null) {
        price = zoneVariations[0]['price'].toString();
      }
    } catch (_) {
      price = '';
    }

    // ------- MRP (same as price or blank) -------
    final mrp = price;

    // ------- Add product -------
    result.products!.add(
      ProductItemModel(
        id: srv['id'],
        title: title,
        description: description,
        thumbnails: thumbnails,
        price: price,
        mrp: mrp,
      ),
    );
  }

  return result;
}

class ProductItemModel {
  String? id;
  String? title;
  String? description;
  List<dynamic>? thumbnails;
  String? price;
  String? mrp;
  Map<String, dynamic>? extra;

  ProductItemModel({
    this.id,
    this.title,
    this.description,
    this.thumbnails,
    this.mrp,
    this.price,
    this.extra,
  });

  factory ProductItemModel.fromJson(Map<String, dynamic> json) {
    return ProductItemModel(
      id: json['id'].toString(),
      title: json['title'],
      description: json['short_description'],
      thumbnails: json['images'],
      price: json['price'],
      mrp: json['mrp'],
      extra: json['extra'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['thumbnails'] = thumbnails;
    data['price'] = price;
    data['mrp'] = mrp;
    data['extra'] = extra;
    return data;
  }

}
