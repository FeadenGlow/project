import java.util.*;

public class SubstringOccurrences {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        String substringToFind = args[0];

        ArrayList<String> lines = new ArrayList<>();
        while (scanner.hasNextLine()) {
            lines.add(scanner.nextLine());
        }

        ArrayList<Occurrence> occurrences = new ArrayList<>();
        for (int i = 0; i < lines.size(); i++) {
            int occurrencesCount = countOccurrences(lines.get(i), substringToFind);
            if (occurrencesCount > 0) {
                occurrences.add(new Occurrence(occurrencesCount, i));
            }
        }

        bubbleSort(occurrences);

        for (Occurrence occurrence : occurrences) {
            System.out.println(occurrence.count + " " + occurrence.lineIndex);
        }
    }

    private static int countOccurrences(String line, String substring) {
        int count = 0;
        int lastIndex = 0;
        while ((lastIndex = line.indexOf(substring, lastIndex)) != -1) {
            count++;
            lastIndex += substring.length();
        }
        return count;
    }

    private static class Occurrence {
        int count; 
        int lineIndex; 

        Occurrence(int count, int lineIndex) {
            this.count = count;
            this.lineIndex = lineIndex;
        }
    }

    private static void bubbleSort(ArrayList<Occurrence> occurrences) {
        int n = occurrences.size();
        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < n - i - 1; j++) {
                if (occurrences.get(j).count > occurrences.get(j + 1).count) {
                    // Обмін елементів
                    Occurrence temp = occurrences.get(j);
                    occurrences.set(j, occurrences.get(j + 1));
                    occurrences.set(j + 1, temp);
                }
            }
        }
    }
}