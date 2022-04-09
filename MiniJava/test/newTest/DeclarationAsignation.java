class DeclarationAsignation {
    public static void main(String[] a) {

        int counter = 0;
        int counter2 = counter++;
        int counter3 = ++counter;
        int counter4 = counter+counter3;
        boolean flag = true;
        boolean notflag = !flag;

        if (flag){
            System.out.println(counter);
            System.out.println(counter2);
            System.out.println(counter3);
        }

        if(notflag){
            System.out.println(10000);
        }else{
            System.out.println(counter4);
        }

    }
}
