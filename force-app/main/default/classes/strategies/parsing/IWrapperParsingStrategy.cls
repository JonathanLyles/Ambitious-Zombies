public interface IWrapperParsingStrategy {
    Map<String, List<Object>> parse(Object wrapper);
}