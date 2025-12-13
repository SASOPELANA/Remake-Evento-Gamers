import ingles from "./en.json";
import spanish from "./es.json";

const LENGUAGES = {
  SPANISH: "es",
  INGLES: "en",
};

export const getI18n = ({
  currentLocale = "es",
}: {
  currentLocale: string | undefined;
}) => {
  switch (currentLocale) {
    case LENGUAGES.INGLES:
      return ingles;
    case LENGUAGES.SPANISH:
      return spanish;
    default:
      return spanish;
  }
};
