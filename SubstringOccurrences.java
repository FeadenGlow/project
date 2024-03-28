import java.util.*;

public class SubstringOccurrences {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        List<String> lines = new ArrayList<>();

        while (scanner.hasNextLine()) {
            String line = scanner.nextLine();
            if (line.isEmpty()) break; 
            lines.add(line);
        }

        System.out.print("Введіть підрядок для пошуку: ");
        String substring = scanner.next();

        List<SubstringEntry> entries = new ArrayList<>();
        for (int i = 0; i < lines.size(); i++) {
            String currentLine = lines.get(i);
            int count = countSubstringOccurrences(currentLine, substring);
            entries.add(new SubstringEntry(count, i));
        }

        Collections.sort(entries);

        for (SubstringEntry entry : entries) {
            System.out.println(entry.getCount() + " " + entry.getLineIndex());
        }
    }

    private static int countSubstringOccurrences(String str, String substr) {
        int count = 0;
        int lastIndex = 0;
        while ((lastIndex = str.indexOf(substr, lastIndex)) != -1) {
            count++;
            lastIndex += substr.length();
        }
        return count;
    }
}

class SubstringEntry implements Comparable<SubstringEntry> {
    private final int count;
    private final int lineIndex;

    public SubstringEntry(int count, int lineIndex) {
        this.count = count;
        this.lineIndex = lineIndex;
    }

    public int getCount() {
        return count;
    }

    public int getLineIndex() {
        return lineIndex;
    }

    @Override
    public int compareTo(SubstringEntry other) {
        return Integer.compare(this.count, other.count);
    }
}