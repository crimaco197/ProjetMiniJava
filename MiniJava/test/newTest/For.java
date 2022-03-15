class For {
    public static void main(String[] a) {
        {
            for (int i = 0; i < 2; i++) {
                System.out.println(i>3);
            }
        }
    }
}

/**
class Fac {
    public int computeFac(int num) {
        int numAux;
        if (num < 1) numAux = 1;
        else numAux = num * (this.computeFac(num-1));
        return numAux;
    }
}
 */

