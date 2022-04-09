class Factorial {
    public static void main(String[] a) {
        {
            System.out.println(2<3);

        }
    }
}


class Fac {
    public int computeFac(int num) {
        int numAux;
        if (num < 1) numAux = 1;
        else numAux = num * (this.computeFac(num-1));
        return numAux;
    }
}


