

String formatNumber (double pay) {
      String roundedPay = pay.toStringAsFixed(2);
      int count = 0;
      for (int i = 3; i < roundedPay.length; i++) {
        if (count == 3) {
          roundedPay = '${roundedPay.substring(0, roundedPay.length - i)},${roundedPay.substring(roundedPay.length - i)}';
          count = 0;
        }
        else {
          count += 1;
        }
      }
      String output = '£$roundedPay';

      return output;
    }
