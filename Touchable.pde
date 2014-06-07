
import java.util.Vector;

import TUIO.TuioClient;
import TUIO.TuioCursor;

public interface Touchable {
  public void touchOne(Vector<TuioCursor> cursors);
  public void touchTwo(Vector<TuioCursor> cursors);
  public void touchThree(Vector<TuioCursor> cursors);
}

